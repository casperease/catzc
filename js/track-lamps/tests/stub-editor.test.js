// The lamps activated in a stub editor: each scenario of stub-editor.js runs in its own node process over its own small repository and
// returns what the stub recorded.
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const { folder } = require("./fixture.js");

const extension = path.resolve(__dirname, "../extension.js").split(path.sep).join("/");
// The extension's folder, repository-relative, as the build writes it into the installed package's catzc.source.
const source = path.relative(path.resolve(__dirname, "../../.."), path.dirname(extension)).split(path.sep).join("/");
const scenario = (/** @type {string} */ name, withEngine = false, files = ["code/a.ps1", "docs/x.md"]) => {
    // The repository in a folder of a short name, so the status line's words fit as they do for the real repository's.
    const root = `${folder(files.map((file) => `w/${file}`))}/w`;
    let driven = extension;
    if (withEngine) {
        // The workspace's engine at its source folder, and an installed package beside it whose shell loads that engine.
        const parts = fs.readdirSync(path.dirname(extension)).filter((file) => file.endsWith(".js"));
        const engine = path.join(root, source);
        const installed = path.join(folder([]), "installed");
        for (const target of [engine, installed]) {
            fs.mkdirSync(target, { recursive: true });
            for (const part of parts) fs.copyFileSync(path.join(path.dirname(extension), part), path.join(target, part));
        }
        fs.writeFileSync(path.join(installed, "package.json"), JSON.stringify({ catzc: { source } }));
        driven = path.join(installed, "extension.js").split(path.sep).join("/");
    }
    const output = execFileSync(process.execPath, [path.join(__dirname, "stub-editor.js"), name, root, driven], {
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

test("stands two ticked languages in the row, puts one out and vetoes the other, and takes both out again when unticked, the status line naming each", () => {
    const result = scenario("languages", false, ["code/a.ps1", "code/a.wdg", "docs/x.md", "docs/b.gdg"]);
    const { start, ticked, switched, unticked } = result.steps;
    const shown = (/** @type {any} */ step, /** @type {string} */ lamp) => step.keys[`catzc.lamps.shown.${lamp}`];
    for (const lamp of ["lang-widget", "lang-gadget"]) {
        assert.strictEqual(shown(start, lamp), false, `${lamp} stands in no row before it is ticked`);
        assert.strictEqual(shown(ticked, lamp), true, `ticking ${lamp} stands it in the row with no reload`);
        assert.strictEqual(ticked.keys[`catzc.lamps.out.${lamp}`], false, `${lamp} comes in lit`);
        assert.strictEqual(ticked.keys[`catzc.lamps.state.${lamp}`], "committed", `${lamp} has its condition`);
        assert.strictEqual(shown(unticked, lamp), false, `unticking ${lamp} takes it out of the row`);
    }
    assert.strictEqual(switched.keys["catzc.lamps.out.lang-widget"], true, "the first is put out");
    assert.strictEqual(switched.keys["catzc.lamps.veto.lang-widget"], false);
    assert.strictEqual(switched.keys["catzc.lamps.veto.lang-gadget"], true, "the second is vetoed");
    assert.deepStrictEqual(switched.hidden, ["**/*.gdg"], "the veto hides its zone; the code lamp still shows the put-out widget file");
    assert.strictEqual(switched.status, "$(pass) w − lang-widget ∖ lang-gadget", "the status words name both language lamps");
    assert.strictEqual(ticked.status, "$(pass) w");
    assert.strictEqual(unticked.status, "$(pass) w");
    assert.deepStrictEqual(unticked.hidden, [], "an unticked language's switches go with its lamp");
    assert.deepStrictEqual(result.remembered, { ticked: [], out: [], vetoed: [] });
});

test("words the problem of a failed test file with its count, runner, levels, run and process", () => {
    const { failureMessage } = require("../engine.js");
    const run = {
        failedCount: 4,
        runner: "Invoke-TestFile",
        pid: 1234,
        runDirectory: "C:\\widget\\out\\test-file\\20261029-231202-c7f456",
    };
    assert.strictEqual(
        failureMessage({ ...run, scope: { minLevel: 0, maxLevel: 2, category: "Both" } }),
        "4 failed in Invoke-TestFile, L0-L2, run 20261029-231202-c7f456 (pid 1234)",
    );
    assert.strictEqual(failureMessage(undefined), "its last test run failed");
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
