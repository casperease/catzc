// The lamps around the language: the red journey, the orchestrator, the open lamp and its editors, and the order of the lamps.
const test = require("node:test");
const assert = require("node:assert");

const { engine, set, filters } = require("./fixture.js");

test("walks the red journey through the failed files in path order, round to the first, starting at the first when none is open", () => {
    const failed = ["mods/b.ps1", "mods/a.ps1", "docs/x.md"];
    assert.strictEqual(engine.nextFailed(failed, null), "docs/x.md");
    assert.strictEqual(engine.nextFailed(failed, "docs/x.md"), "mods/a.ps1");
    assert.strictEqual(engine.nextFailed(failed, "mods/b.ps1"), "docs/x.md", "the journey goes round");
    assert.strictEqual(engine.nextFailed(failed, "gadgets/other.ps1"), "docs/x.md", "a file that is not failed starts the journey over");
    assert.strictEqual(engine.nextFailed([], "mods/a.ps1"), null);
});

test("sums the whole repository into the orchestrator's colour: red for any failure, blue for any work in progress, green for neither", () => {
    assert.strictEqual(engine.summaryOf({ "a.ps1": { change: "unstaged" }, "b.ps1": { fault: "failed" } }), "red");
    assert.strictEqual(engine.summaryOf({ "a.ps1": { change: "staged" } }), "blue");
    assert.strictEqual(engine.summaryOf({}), "green");
});

test("lights every red lamp on the orchestrator's click, lifting its veto, and leaves every other lamp as it was", () => {
    const next = engine.revealFailed(
        { code: "failed", tests: "unstaged", docs: "failed", tools: "committed" },
        ["code", "tests", "docs"],
        ["docs", "tests"],
    );
    assert.deepStrictEqual(next.out, ["tests"], "code and docs are red, so they are lit; tests is not red, so it stays out");
    assert.deepStrictEqual(next.vetoed, ["tests"], "docs was vetoed and red, so its veto is lifted; tests keeps its veto");
});

test("turns the open lamp red only while a red file is open, and back to the open files' own colour once it is closed", () => {
    const red = "mods/Widget/Get-Widget.ps1";
    const other = "gadgets/a.ps1";
    // The red file's fault stays a fact after its tab closes (it is remembered), so only the open set decides the open lamp.
    const facts = { [red]: { fault: "failed" }, [other]: { change: "unstaged" } };
    const condition = (/** @type {string[]} */ open) =>
        engine.evaluate(engine.lampSets(filters, open), new Set(["open"]), [], facts).conditions.open;
    assert.strictEqual(condition([red, other]), "failed", "a red file is open");
    assert.strictEqual(condition([other]), "unstaged", "the red file is closed, so the open lamp shows the open file's own colour");
    assert.strictEqual(condition([]), "empty", "with every document closed the open lamp claims nothing");
});

test("reads the open lamp's files from the editor's tabs: a text tab's file and a diff tab's modified side, none outside the root", () => {
    const root = "/widget-repo";
    const uri = (/** @type {string} */ fsPath, scheme = "file") => ({ scheme, fsPath });
    const groups = [
        {
            tabs: [
                { input: { uri: uri(`${root}/mods/Widget/Get-Widget.ps1`) } },
                { input: { modified: uri(`${root}/gadgets/a.ps1`), original: uri(`${root}/gadgets/a.ps1`, "git") } },
            ],
        },
        {
            tabs: [
                { input: { uri: uri(`${root}/mods/Widget/Get-Widget.ps1`) } },
                { input: { uri: uri("untitled-1", "untitled") } },
                { input: null },
            ],
        },
        { tabs: [{ input: { uri: uri("/elsewhere/x.ps1") } }] },
    ];
    assert.deepStrictEqual(engine.openFiles(root, groups), ["gadgets/a.ps1", "mods/Widget/Get-Widget.ps1"]);
});

test("puts the open lamp first and the filters next in their order, and makes no editor open an empty lamp", () => {
    const sets = engine.lampSets(filters, ["mods/Widget/Get-Widget.ps1"]);
    assert.deepStrictEqual(Object.keys(sets), ["open", ...Object.keys(filters)]);
    assert.strictEqual(engine.evaluate(sets, new Set(["open"]), [], {}).conditions.open, "committed");
    assert.strictEqual(engine.evaluate(engine.lampSets(filters, []), new Set(["open"]), [], {}).conditions.open, "empty");
});

test("counts every tab of every group as an open editor, so the open lamp moves focus only with two or more", () => {
    assert.strictEqual(engine.editorCount([]), 0);
    assert.strictEqual(engine.editorCount([{ tabs: [1] }]), 1);
    assert.strictEqual(engine.editorCount([{ tabs: [1, 2] }, { tabs: [3] }]), 3);
});

test("keeps the open lamp's sets one include per open file", () => {
    assert.deepStrictEqual(engine.lampSets(filters, ["a.md"]).open, [set(["a.md"])]);
});
