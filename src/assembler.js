if (process.argv.length !== 4) {
  console.error(
    "Usage: bun assembler-auto/assembler.js <asm-input> <sheet-output>",
  );
  process.exit(1);
}

const asmInput = process.argv[2];
const sheetOutput = process.argv[3];
const code = await Bun.file(asmInput).text();
const rawPreviewTemplate = await Bun.file(
  new URL("./preview.lua", import.meta.url),
).text();
const rawVmFormula = await Bun.file(
  new URL("./vm.lua", import.meta.url),
).text();

const ops = {
  lte: 0,
  add: 1,
  load: 2,
  load_a: 3,
  store: 4,
  store_a: 5,
  jmp0: 6,
  jmp0_a: 7,
  jmp: 8,
  jmp_a: 9,
  halt: 10,
  sub: 11,
  mul: 12,
  set: 13,
};

const out = [[0]];
const labelReferences = [{ label: "_start", x: 0, y: 0 }];
const labels = new Map();

function concretify(token, x) {
  const parsed = Number.parseInt(token, 10);
  if (Number.isNaN(parsed)) {
    labelReferences.push({ label: token, y: out.length, x });
    return 0;
  }
  return parsed;
}

for (const line of code.split("\n")) {
  const tokens = line.trim().split(/\s+/g).filter(Boolean);
  for (let i = 0; i < tokens.length; i++) {
    if (tokens[i].startsWith(";")) {
      tokens.splice(i);
      break;
    }
  }
  if (tokens.length === 0) continue;

  if (tokens[1] === "=") {
    const assignment = tokens
      .slice(2)
      .map((token, x) => concretify(token, x, out.length));
    if (labels.has(tokens[0]))
      throw new Error(`Label '${tokens[0]}' is already set`);
    labels.set(tokens[0], out.length - 1);
    out.push(assignment);
  } else if (tokens[0].endsWith(":")) {
    const label = tokens[0].slice(0, -1);
    if (labels.has(label)) throw new Error(`Label '${label}' is already set`);
    labels.set(label, out.length - 1);
  } else {
    const opcode = ops[tokens[0]];
    if (opcode === undefined) throw new Error(`Unknown op '${tokens[0]}'`);
    out.push([
      opcode,
      ...tokens
        .slice(1)
        .map((token, i) => concretify(token, i + 1, out.length)),
    ]);
  }
}

for (const { label, y, x } of labelReferences) {
  if (!labels.has(label)) throw new Error(`Label '${label}' not found`);
  out[y][x] = labels.get(label);
}

function encodeLine(line) {
  const cells = [];
  for (let i = 0; i < line.length; i += 16666) {
    const chunk = line.slice(i, i + 16666);
    const encodedCell = chunk
      .map((val) => {
        const unsigned = val >>> 0;
        const a = (unsigned >>> 17) & 0x7fff;
        const b = (unsigned >>> 2) & 0x7fff;
        const c = unsigned & 0x3;

        return (
          String.fromCharCode(a + 32) +
          String.fromCharCode(b + 32) +
          String.fromCharCode(c + 32)
        );
      })
      .join("");
    cells.push(`[${encodedCell}]`);
  }
  return cells;
}

function toSingleLineFormula(formula) {
  return formula.replace(/\r?\n\s*/g, " ").trim();
}

const previewTemplate = toSingleLineFormula(rawPreviewTemplate);
const vmFormula = toSingleLineFormula(rawVmFormula);

function previewFormulaForRow(row) {
  return previewTemplate.replace(/\bE8\b/g, `E${row}`);
}

const encodedRows = out.map(encodeLine);
const START_ROW = 8;
const END_ROW = 101;
const COLUMN_COUNT = 7;
const sheetRows = [];

for (let row = 1; row <= END_ROW; row++) {
  const cells = Array(COLUMN_COUNT).fill("");

  if (row === 1) {
    cells[0] = "Output:";
    cells[1] = '=IFERROR(D11,"")';
  } else if (row === 3) {
    cells[0] = "Run:";
    cells[1] = "FALSE";
  } else if (row === 7) {
    cells[1] = "initial";
    cells[3] = "live";
    cells[4] = "live";
  } else if (row >= START_ROW) {
    const matrixRow = row - START_ROW;
    const encoded = encodedRows[matrixRow] ?? [];

    cells[0] = matrixRow === 0 ? "PC" : String(matrixRow - 1);
    cells[1] = encoded[0] ?? "[   ]";
    cells[2] = encoded.slice(1).join("");
    cells[3] = previewFormulaForRow(row);
    if (row === START_ROW) cells[4] = vmFormula;
  }

  sheetRows.push(cells.join("\t"));
}

await Bun.file(sheetOutput).write(sheetRows.join("\n"));
console.log(":)");
