// The lamps activated in a stub editor: each scenario of stub-editor.js runs in its own node process over its own small repository and
// returns what the stub recorded.
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const { folder } = require("./fixture.js");

const extension = path.resolve(__dirname, "../extension.js").split(path.sep).join("/");
const scenario = (/** @type {string} */ name, withEngine = false) => {
    const root = folder(["code/a.ps1", "docs/x.md"]);
    if (withEngine) {
        const engine = path.join(root, "js/catzc-track-lamps");
        fs.mkdirSync(engine, { recursive: true });
        for (const part of fs.readdirSync(path.dirname(extension)).filter((file) => file.endsWith(".js")))
            fs.copyFileSync(path.join(path.dirname(extension), part), path.join(engine, part));
    }
    const output = execFileSync(process.execPath, [path.join(__dirname, "stub-editor.js"), name, root, extension], {
        encoding: "utf8",
        timeout: 60000,
    });
    return JSON.parse(output);
};

test("keeps a lamp that is not shipped out of the title row, logs the mismatch once, and sends no key when nothing changed", () => {
    const result = scenario("keys");
    assert.strictEqual(result.shownCode, true);
    assert.strictEqual(result.shownWidget, false, "the preview flag is off, so only shipped lamps reach the menu");
    assert.ok(result.summary, "the orchestrator always has a colour");
    assert.strictEqual(result.mismatchLogs, 1, "the shipped-lamps assert speaks once per mismatch, not on every call");
    assert.strictEqual(result.sentAfterNoChange, 0, "a re-judge that changes nothing sends no context key");
});

test("runs presses through one queue: no write overlaps another, and the last press has the last word", () => {
    const result = scenario("queue");
    assert.strictEqual(result.maxConcurrent, 1);
    assert.ok(result.afterThree.includes("code"), "code was put out and docs vetoed, so code is hidden");
    assert.ok(result.afterThree.includes("docs"));
    assert.deepStrictEqual(result.last, [], "both lamps were lit again by the last presses, so nothing is hidden");
    assert.deepStrictEqual(result.out, []);
});

test("keeps the disk index current from the editor's file events", () => {
    const result = scenario("index");
    assert.deepStrictEqual(result.before, ["docs"]);
    assert.deepStrictEqual(result.afterCreate, ["docs", "notes"], "a created file the unlit docs lamp claims is hidden at once");
    assert.deepStrictEqual(result.afterDelete, ["notes"], "the deleted file leaves docs empty on disk, and an empty folder shows");
});

test("swaps the repository's engine on a save, every old part disposed first, and falls back to its own copy when it does not load", () => {
    const result = scenario("swap", true);
    assert.strictEqual(result.first.light, true, "the shell runs the repository's engine");
    assert.strictEqual(result.swapped.light, true);
    assert.ok(result.swapped.registered > result.first.registered, "the saved engine registered its commands anew");
    assert.ok(result.swapped.disposed > 0, "the old engine was disposed before the new one started");
    assert.strictEqual(result.broken.light, true, "the package's own copy runs when the repository's does not load");
    assert.strictEqual(result.broken.fellBack, true);
    assert.deepStrictEqual(result.duplicates, [], "no command is ever registered twice at once");
});
