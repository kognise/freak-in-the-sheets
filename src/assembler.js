const code = await Bun.file('./src/fib.asm').text()

const out = [
    ['<_start>']
]
const labelReferences = [
    { label: '_start', x: 0, y: 0 }
]
const labels = new Map()

function concretify(token, x, y) {
    const parsed = Number.parseInt(token, 10)
    if (Number.isNaN(parsed)) {
        // Label reference
        labelReferences.push({ label: token, y: out.length, x })
        return `<${token}>`
    } else {
        // Value
        return parsed
    }
}

for (const line of code.split('\n')) {
    const tokens = line.trim().split(/\s+/g).filter(Boolean)
    for (let i = 0; i < tokens.length; i++) {
        if (tokens[i].startsWith('#')) {
            tokens.splice(i)
            break
        }
    }
    if (tokens.length === 0) continue

    if (tokens[1] === '=') {
        // Assignment
        const line = tokens.slice(2).map((token, x) => concretify(token, x, out.length))
        if (labels.has(tokens[0])) throw new Error(`Label '${tokens[0]}' is already set`)
        labels.set(tokens[0], out.length - 1)
        out.push(line)
    } else if (tokens[0].endsWith(':')) {
        // Label
        const label = tokens[0].slice(0, -1)
        if (labels.has(label)) throw new Error(`Label '${label}' is already set`)
        labels.set(label, out.length - 1)
    } else {
        // Instruction
        out.push([tokens[0], ...tokens.slice(1).map((token, i) => concretify(token, i + 1, out.length))])
    }
}

for (const { label, y, x } of labelReferences) {
    if (!labels.has(label)) throw new Error(`Label '${label}' not found`)
    out[y][x] = labels.get(label)
}

await Bun.file('./out.sheet').write(out.map(line => line.join('\t')).join('\n'))
console.log(':)')