const asmInput = process.argv[2] ?? "./src/fib.asm";
const sheetOutput = process.argv[3] ?? "./out.sheet";
const code = await Bun.file(asmInput).text();

const ops = {
  "<=": 0,
  lte: 0,
  add: 1,
  sub: 11,
  mul: 12,
  load: 2,
  load_a: 3,
  store: 4,
  store_a: 5,
  jmp0: 6,
  jmp0_a: 7,
  jmp: 8,
  jmp_a: 9,
  halt: 10,
};

const out = [[0]];
const labelReferences = [{ label: "_start", x: 0, y: 0 }];
const labels = new Map();

function concretify(token, x, y) {
  const parsed = Number.parseInt(token, 10);
  if (Number.isNaN(parsed)) {
    // Label reference
    labelReferences.push({ label: token, y: out.length, x });
    return 0;
  } else {
    // Value
    return parsed;
  }
}

for (const line of code.split("\n")) {
  const tokens = line.trim().split(/\s+/g).filter(Boolean);
  for (let i = 0; i < tokens.length; i++) {
    if (tokens[i].startsWith("#")) {
      tokens.splice(i);
      break;
    }
  }
  if (tokens.length === 0) continue;

  if (tokens[1] === "=") {
    // Assignment
    const line = tokens
      .slice(2)
      .map((token, x) => concretify(token, x, out.length));
    if (labels.has(tokens[0]))
      throw new Error(`Label '${tokens[0]}' is already set`);
    labels.set(tokens[0], out.length - 1);
    out.push(line);
  } else if (tokens[0].endsWith(":")) {
    // Label
    const label = tokens[0].slice(0, -1);
    if (labels.has(label)) throw new Error(`Label '${label}' is already set`);
    labels.set(label, out.length - 1);
  } else {
    // Instruction
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

const sheet = out.map((line) => {
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
});
await Bun.file(sheetOutput).write(
  sheet.map((row) => row.join("\t")).join("\n"),
);
console.log(":)");
