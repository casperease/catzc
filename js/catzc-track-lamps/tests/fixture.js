// The small repository the engine-core tests classify: a widget module with its test and README, a gadget, a doc; and the sets of its
// five filters. Every test reads it, none writes into it, so a test that needs other files makes its own folder with folder().
const fs = require("fs");
const os = require("os");
const path = require("path");

const engine = require("../extension.js");

const set = (/** @type {string[]} */ include, /** @type {string[]} */ exclude = []) => ({ include, exclude });
const filters = {
    code: [set(["mods/Widget/Get-Widget.ps1"])],
    tests: [set(["mods/Widget/**"], ["mods/Widget/Get-Widget.ps1"])],
    tools: [set(["gadgets", "gadgets/**"])],
    generated: [set(["**/README.md"])],
    docs: [set(["docs", "docs/**"])],
};

// A fresh folder under the system's temp folder, '/'-separated, holding the given files (empty) and folders.
const folder = (/** @type {string[]} */ files = [], /** @type {string[]} */ folders = []) => {
    const root = fs.mkdtempSync(path.join(os.tmpdir(), "catzc-lamps-")).replace(/\\/g, "/");
    for (const file of files) {
        fs.mkdirSync(path.dirname(path.join(root, file)), { recursive: true });
        fs.writeFileSync(path.join(root, file), "");
    }
    for (const inner of folders) fs.mkdirSync(path.join(root, inner), { recursive: true });
    return root;
};
const root = folder(["mods/Widget/Get-Widget.ps1", "mods/Widget/tests/Get-Widget.Tests.ps1", "mods/Widget/README.md", "gadgets/a.ps1", "docs/x.md"]);

// The globs the lamps write for the switches given: out the unlit lamps, vetoed the lamps that hide their zone.
const hidden = (/** @type {string[]} */ out, at = root, /** @type {string[]} */ vetoed = []) => engine.hiddenGlobs(at, new Set(out), filters, [], vetoed);

module.exports = { engine, set, filters, folder, root, hidden };
