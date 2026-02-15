from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Callable


@dataclass(frozen=True)
class Instruction:
    op: str
    args: tuple[str, ...]


@dataclass(frozen=True)
class Module:
    entry: str
    blocks: dict[str, list[Instruction]]


@dataclass(frozen=True)
class Address:
    row: str
    col: str


_NAME = r"[%@][A-Za-z$._0-9-]+"


def parse_llvm_ir(text: str, source_name: str = "<llvm-ir>") -> Module:
    blocks: dict[str, list[Instruction]] = {}
    current_block: str | None = None
    in_main = False

    for line_number, raw in enumerate(text.splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith(";"):
            continue

        if line.startswith("define ") and "@main" in line:
            in_main = True
            continue
        if not in_main:
            continue
        if line == "}":
            break

        label_match = re.match(r"^([A-Za-z$._0-9-]+):", line)
        if label_match:
            current_block = label_match.group(1)
            blocks.setdefault(current_block, [])
            continue

        if current_block is None:
            current_block = "entry"
            blocks.setdefault(current_block, [])

        try:
            parsed = _parse_instruction(line)
        except ValueError as err:
            # Keep errors clickable in terminals/editors that support "path:line" links.
            raise ValueError(f"{source_name}:{line_number}: {err}") from None
        if parsed is not None:
            blocks[current_block].append(parsed)

    if not blocks:
        raise ValueError("No parseable `main` function blocks found in LLVM IR")
    entry = "entry" if "entry" in blocks else next(iter(blocks))
    return Module(entry=entry, blocks=blocks)


def _parse_instruction(line: str) -> Instruction | None:
    for pattern, builder in _PATTERNS:
        match = re.match(pattern, line)
        if match:
            return builder(match)

    if line.startswith("call "):
        return None
    if line.startswith("ret void"):
        return Instruction("ret", tuple())
        
    raise ValueError(f"Unsupported LLVM instruction: {line}")


def _clean_label(token: str) -> str:
    return token.strip().lstrip("%")


def _sym(token: str) -> str:
    return token.strip()


def _parse_call_args(arg_text: str) -> tuple[str, ...]:
    args: list[str] = []
    for raw in arg_text.split(","):
        token = raw.strip()
        if not token:
            continue
        match = re.search(rf"({_NAME}|-?\d+)\s*$", token)
        if match is None:
            raise ValueError(f"Unsupported call argument: {token}")
        args.append(_sym(match.group(1)))
    return tuple(args)


_PATTERNS: list[tuple[str, Callable[[re.Match[str]], Instruction]]] = [
    (
        rf"^({_NAME})\s*=\s*alloca\s+\[(\d+)\s+x\s+i(\d+)\].*$",
        lambda m: Instruction("alloca_array", (_sym(m.group(1)), m.group(2), m.group(3))),
    ),
    (
        rf"^({_NAME})\s*=\s*alloca\s+i(\d+).*$",
        lambda m: Instruction("alloca_scalar", (_sym(m.group(1)), m.group(2))),
    ),
    (
        rf"^store\s+i\d+\s+([^,]+),\s+ptr\s+([^,]+).*$",
        lambda m: Instruction("store", (_sym(m.group(1)), _sym(m.group(2)))),
    ),
    (
        rf"^({_NAME})\s*=\s*load\s+i\d+,\s+ptr\s+([^,]+).*$",
        lambda m: Instruction("load", (_sym(m.group(1)), _sym(m.group(2)))),
    ),
    (
        rf"^({_NAME})\s*=\s*(add|sub|mul|and|or|xor|shl|lshr|ashr)\b(?:\s+\w+)*\s+i\d+\s+([^,]+),\s+(.+)$",
        lambda m: Instruction(
            "binop", (_sym(m.group(1)), m.group(2), _sym(m.group(3)), _sym(m.group(4)))
        ),
    ),
    (
        rf"^({_NAME})\s*=\s*icmp\s+(\w+)\s+i\d+\s+([^,]+),\s+(.+)$",
        lambda m: Instruction(
            "icmp", (_sym(m.group(1)), m.group(2), _sym(m.group(3)), _sym(m.group(4)))
        ),
    ),
    (
        rf"^({_NAME})\s*=\s*getelementptr\b.*\bi8,\s+ptr\s+([^,]+),\s+i\d+\s+(.+)$",
        lambda m: Instruction("gep_byte", (_sym(m.group(1)), _sym(m.group(2)), _sym(m.group(3)))),
    ),
    (
        rf"^({_NAME})\s*=\s*getelementptr\b.*,\s+ptr\s+({_NAME}),\s+i\d+\s+([^,]+),\s+i\d+\s+(.+)$",
        lambda m: Instruction("gep", (_sym(m.group(1)), _sym(m.group(2)), _sym(m.group(4)))),
    ),
    (
        rf"^({_NAME})\s*=\s*call\s+i\d+\s+@([A-Za-z$._0-9-]+)\((.*)\).*$",
        lambda m: Instruction("call", (_sym(m.group(1)), m.group(2), *_parse_call_args(m.group(3)))),
    ),
    (
        rf"^({_NAME})\s*=\s*(?:sext|zext|trunc|bitcast)\b.*\s+({_NAME}|-?\d+)\s+to\s+.*$",
        lambda m: Instruction("cast", (_sym(m.group(1)), _sym(m.group(2)))),
    ),
    (
        rf"^br\s+i1\s+([^,]+),\s+label\s+%([^,]+),\s+label\s+%([A-Za-z$._0-9-]+).*$",
        lambda m: Instruction("br_cond", (_sym(m.group(1)), _clean_label(m.group(2)), _clean_label(m.group(3)))),
    ),
    (
        r"^br\s+label\s+%([A-Za-z$._0-9-]+).*$",
        lambda m: Instruction("br", (_clean_label(m.group(1)),)),
    ),
    (
        r"^ret\s+\w+\s+(.+)$",
        lambda m: Instruction("ret", (_sym(m.group(1)),)),
    ),
]


def emit_shasm(module: Module) -> str:
    emitter = _Emitter(module)
    return emitter.emit()


class _Emitter:
    def __init__(self, module: Module) -> None:
        self.module = module
        self.const_symbols: dict[int, str] = {}
        self.pointer_slots: dict[str, Address] = {}
        self.pointer_elem_bytes: dict[str, int] = {}
        self.value_slots: dict[str, str] = {}
        self.declarations: list[str] = []
        self.declared_rows: set[str] = set()
        self.const_32: str | None = None
        self.block_labels: dict[str, str] = {
            name: self._block_label(name) for name in module.blocks
        }

    def emit(self) -> str:
        self._scan_declarations()
        body: list[str] = []
        body.append("_start:")
        body.append(f"    jmp {self.block_labels[self.module.entry]}")

        for block_name, instructions in self.module.blocks.items():
            body.append(f"{self.block_labels[block_name]}:")
            for inst in instructions:
                body.extend(self._emit_instruction(inst))

        return "\n".join([*self.declarations, *body]).strip() + "\n"

    def _scan_declarations(self) -> None:
        self._declare_const(0)
        self._declare_const(1)
        self._declare_row("out", ["0"])

        for instructions in self.module.blocks.values():
            for inst in instructions:
                self._scan_instruction(inst)

    def _scan_instruction(self, inst: Instruction) -> None:
        if inst.op == "alloca_scalar":
            ptr, bits_text = inst.args
            row = self._slot_name(ptr)
            self._declare_row(row, ["0"])
            self.pointer_slots[ptr] = Address(row=row, col=self._const(0))
            self.pointer_elem_bytes[ptr] = self._bits_to_bytes(bits_text)
            return

        if inst.op == "alloca_array":
            ptr, size_text, bits_text = inst.args
            size = int(size_text)
            row = self._slot_name(ptr)
            self._declare_row(row, ["0"] * size)
            self.pointer_slots[ptr] = Address(row=row, col=self._const(0))
            self.pointer_elem_bytes[ptr] = self._bits_to_bytes(bits_text)
            return

        if inst.op in {"load", "binop", "icmp", "cast", "call"}:
            result = inst.args[0]
            row = self._slot_name(result)
            self._declare_row(row, ["0"])
            self.value_slots[result] = row
            if inst.op == "call":
                _, func_name, *call_args = inst.args
                if func_name == "rotr32":
                    if len(call_args) != 2:
                        raise ValueError(f"Unsupported rotr32 arity: {len(call_args)}")
                    self._declare_row(f"{row}_rot_shift", ["0"])
                    self._declare_row(f"{row}_rot_right", ["0"])
                    self._declare_row(f"{row}_rot_left", ["0"])
                elif func_name == "lshr32":
                    if len(call_args) != 2:
                        raise ValueError(f"Unsupported lshr32 arity: {len(call_args)}")
                else:
                    raise ValueError(f"Unsupported call target: {func_name}")

        if inst.op == "gep":
            result, base, index = inst.args
            base_addr = self._pointer(base)
            self.pointer_slots[result] = Address(row=base_addr.row, col=self._value(index))
            self.pointer_elem_bytes[result] = self.pointer_elem_bytes.get(base, 1)
            return

        if inst.op == "gep_byte":
            result, base, byte_offset = inst.args
            base_addr = self._pointer(base)
            self.pointer_slots[result] = Address(
                row=base_addr.row,
                col=self._byte_offset_to_index(base, byte_offset),
            )
            self.pointer_elem_bytes[result] = self.pointer_elem_bytes.get(base, 1)
            return

        if inst.op == "store":
            value, pointer = inst.args
            self._value(value)
            self._pointer(pointer)
            return

        if inst.op == "br_cond":
            cond, true_block, false_block = inst.args
            self._value(cond)
            return

        if inst.op == "br":
            return

        if inst.op == "ret" and inst.args:
            self._value(inst.args[0])

    def _emit_instruction(self, inst: Instruction) -> list[str]:
        if inst.op in {"alloca_scalar", "alloca_array", "gep", "gep_byte"}:
            return []

        if inst.op == "load":
            result, pointer = inst.args
            addr = self._pointer(pointer)
            return [f"    load {self.value_slots[result]} {addr.row} {addr.col}"]

        if inst.op == "store":
            value, pointer = inst.args
            addr = self._pointer(pointer)
            return [f"    store {addr.row} {addr.col} {self._value(value)}"]

        if inst.op == "binop":
            result, op_name, lhs, rhs = inst.args
            opcode = {
                "add": "add",
                "sub": "sub",
                "mul": "mul",
                "and": "and",
                "or": "or",
                "xor": "xor",
                "shl": "shl",
                "lshr": "lshr",
                "ashr": "ashr",
            }.get(op_name)
            if opcode is None:
                raise ValueError(f"Unsupported arithmetic op: {op_name}")
            return [f"    {opcode} {self.value_slots[result]} {self._value(lhs)} {self._value(rhs)}"]

        if inst.op == "icmp":
            result, pred, lhs, rhs = inst.args
            if pred == "sle":
                return [f"    lte {self.value_slots[result]} {self._value(lhs)} {self._value(rhs)}"]
            if pred == "slt":
                rhs_minus_one = f"{self.value_slots[result]}_cmp_rhs_minus_1"
                self._declare_row(rhs_minus_one, ["0"])
                return [
                    f"    sub {rhs_minus_one} {self._value(rhs)} {self._const(1)}",
                    f"    lte {self.value_slots[result]} {self._value(lhs)} {rhs_minus_one}",
                ]
            raise ValueError(f"Unsupported comparison predicate: {pred}")

        if inst.op == "call":
            result, func_name, *call_args = inst.args
            if func_name == "lshr32":
                if len(call_args) != 2:
                    raise ValueError(f"Unsupported lshr32 arity: {len(call_args)}")
                return [f"    lshr {self.value_slots[result]} {self._value(call_args[0])} {self._value(call_args[1])}"]
            if func_name == "rotr32":
                if len(call_args) != 2:
                    raise ValueError(f"Unsupported rotr32 arity: {len(call_args)}")
                if self.const_32 is None:
                    self.const_32 = self._const(32)
                shift_name = f"{self.value_slots[result]}_rot_shift"
                right_name = f"{self.value_slots[result]}_rot_right"
                left_name = f"{self.value_slots[result]}_rot_left"
                return [
                    f"    sub {shift_name} {self.const_32} {self._value(call_args[1])}",
                    f"    lshr {right_name} {self._value(call_args[0])} {self._value(call_args[1])}",
                    f"    shl {left_name} {self._value(call_args[0])} {shift_name}",
                    f"    or {self.value_slots[result]} {right_name} {left_name}",
                ]
            raise ValueError(f"Unsupported call target: {func_name}")

        if inst.op == "cast":
            result, source = inst.args
            return [f"    add {self.value_slots[result]} {self._value(source)} {self._const(0)}"]

        if inst.op == "br_cond":
            cond, true_block, false_block = inst.args
            return [
                f"    jmp0 {self._value(cond)} {self.block_labels[false_block]}",
                f"    jmp {self.block_labels[true_block]}",
            ]

        if inst.op == "br":
            return [f"    jmp {self.block_labels[inst.args[0]]}"]

        if inst.op == "ret":
            lines = []
            if inst.args:
                lines.append(f"    add out {self._value(inst.args[0])} {self._const(0)}")
            lines.append("    halt")
            return lines

        raise ValueError(f"Unsupported instruction op: {inst.op}")

    def _declare_row(self, name: str, values: list[str]) -> None:
        if name in self.declared_rows:
            return
        self.declared_rows.add(name)
        self.declarations.append(f"{name} = {' '.join(values)}")

    def _declare_const(self, value: int) -> str:
        if value in self.const_symbols:
            return self.const_symbols[value]
        symbol = f"const_{'neg_' if value < 0 else ''}{abs(value)}"
        self.const_symbols[value] = symbol
        self._declare_row(symbol, [str(value)])
        return symbol

    def _const(self, value: int) -> str:
        return self._declare_const(value)

    def _slot_name(self, llvm_name: str) -> str:
        safe = re.sub(r"[^A-Za-z0-9_]", "_", llvm_name.lstrip("%@"))
        return f"v_{safe}"

    def _value(self, token: str) -> str:
        token = token.strip()
        if re.fullmatch(r"-?\d+", token):
            return self._const(int(token))
        if token in self.value_slots:
            return self.value_slots[token]
        raise ValueError(f"Unknown value token: {token}")

    def _pointer(self, token: str) -> Address:
        token = token.strip()
        if token in self.pointer_slots:
            return self.pointer_slots[token]
        raise ValueError(f"Unknown pointer token: {token}")

    def _block_label(self, block_name: str) -> str:
        safe = re.sub(r"[^A-Za-z0-9_]", "_", block_name)
        if re.match(r"^\d", safe):
            safe = f"bb_{safe}"
        return safe

    def _bits_to_bytes(self, bits_text: str) -> int:
        bits = int(bits_text)
        return max(1, bits // 8)

    def _byte_offset_to_index(self, base_ptr: str, byte_offset_token: str) -> str:
        token = byte_offset_token.strip()
        stride = self.pointer_elem_bytes.get(base_ptr, 1)
        if re.fullmatch(r"-?\d+", token):
            byte_offset = int(token)
            if byte_offset % stride != 0:
                raise ValueError(
                    f"Unsupported unaligned byte GEP offset: {byte_offset} for stride {stride}"
                )
            return self._const(byte_offset // stride)
        if stride == 1:
            return self._value(token)
        raise ValueError(f"Unsupported dynamic byte GEP offset for stride {stride}: {token}")
