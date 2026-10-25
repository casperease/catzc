// The lamp language over a small repository: what each switch hides, how few entries it writes, and the census that re-checks it.
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const path = require("path");

const { engine, set, filters, folder, root, hidden } = require("./fixture.js");

test("hides nothing while every lamp is lit, which is the default", async () => {
    assert.deepStrictEqual(await hidden([]), []);
});

test("hides exactly what an unlit filter claims", async () => {
    // The module's own .ps1 files go as one level while its tests, the same extension below, show.
    assert.deepStrictEqual(await hidden(["code"]), ["mods/Widget/*.ps1"]);
    assert.deepStrictEqual(await hidden(["tools"]), ["gadgets"]);
});

test("shows a file while any lit lamp claims it, so an unlit lamp hides only what no lit lamp claims (the total union)", async () => {
    assert.deepStrictEqual(await hidden(["generated"]), [], "the README is tests as well as generated, and tests is lit");
    assert.deepStrictEqual(await hidden(["tests"]), ["**/tests"], "the lit generated lamp keeps the README, and no live folder is named tests");
    assert.deepStrictEqual(await hidden(["tests", "generated"]), ["**/tests", "mods/**/*.md"], "no markdown under mods shows");
});

test("classifies by the sets, so an exclude keeps a file out and a new file is classified with no list to update", async () => {
    const added = path.join(root, "mods/Widget/New-Widget.ps1");
    fs.writeFileSync(added, "");
    try {
        assert.deepStrictEqual(await hidden(["code"]), ["mods/Widget/Get-Widget.ps1"], "the new file is no live path");
        assert.deepStrictEqual(await hidden(["tests"]), ["**/tests", "mods/Widget/New-Widget.ps1"]);
    } finally {
        fs.unlinkSync(added);
    }
});

test("takes a folder out of the tree when nothing in it is shown, as its topmost dead folder", async () => {
    assert.deepStrictEqual(await hidden(["code", "tests", "tools", "generated", "docs"]), ["docs", "gadgets", "mods"]);
    const emptyOnDisk = folder(["mods/Widget/Get-Widget.ps1"], ["empty/deeper"]);
    assert.deepStrictEqual(await hidden(["tools"], emptyOnDisk), [], "a folder empty on disk is shown: no lamp claims it");
});

test("takes a vetoed lamp's whole zone out of the tree, even a file a lit lamp claims too (the lit union minus the vetoed zones)", async () => {
    assert.deepStrictEqual(await hidden(["generated"], root,[]), [], "plainly off, generated hides nothing: the README is tests too");
    assert.deepStrictEqual(await hidden(["generated"], root,["generated"]), ["mods/**/*.md"], "vetoed, generated takes the README out");
    const verdict = engine.evaluate(filters, new Set(["code", "tests", "tools"]), ["mods/Widget/README.md", "docs/x.md"], {}, ["docs"]);
    assert.deepStrictEqual(verdict.shown, ["mods/Widget/README.md"], "docs is vetoed, so its file is out");
    assert.deepStrictEqual(verdict.unaccounted, []);
});

test("accounts for every file with a lamp vetoed: the written entries hide exactly what the language does not show", async () => {
    const globs = await hidden(["generated"], root,["generated"]);
    const tally = await engine.census(root, new Set(["generated"]), filters,globs, [], ["generated"]);
    assert.strictEqual(tally.shown, 4);
    assert.deepStrictEqual(tally.wrong, []);
    assert.deepStrictEqual(tally.unclaimed, []);
});

test("writes a path in its on-disk spelling and matches without case on Windows", { skip: process.platform !== "win32" }, async () => {
    const lower = { code: [set(["mods/widget/get-widget.ps1"])] };
    assert.deepStrictEqual(await engine.hiddenGlobs(root, new Set(["code"]), lower), ["mods/Widget/*.ps1"]);
});

test("accounts for every file: its signature, the files shown, and none against its filters or unclaimed", async () => {
    const globs = await hidden(["tests"]);
    const tally = await engine.census(root, new Set(["tests"]), filters,globs);
    assert.strictEqual(tally.total, 5);
    assert.strictEqual(tally.shown, 4);
    assert.strictEqual(tally.signatures["tests+generated"], 1);
    assert.strictEqual(tally.signatures["code"], 1);
    assert.deepStrictEqual(tally.wrong, []);
    assert.deepStrictEqual(tally.unclaimed, []);
});

test("counts the run output apart: the files the out lamp claims never count among the repository's own", async () => {
    const withOutput = folder(["docs/x.md", "out/run/a.log", "out/run/b.log"]);
    const lamps = { docs: filters.docs, out: [set(["out/**"])] };
    const tally = await engine.census(withOutput, new Set(["out"]), lamps,["out"]);
    assert.deepStrictEqual([tally.shown, tally.total], [1, 1], "the repository's own files: the one doc, shown");
    assert.deepStrictEqual(tally.output, { total: 2, shown: 0 }, "the run output, both files hidden while the out lamp is off");
    assert.deepStrictEqual(tally.wrong, []);
    const none = await engine.census(withOutput, new Set(), { docs: filters.docs }, []);
    assert.deepStrictEqual(none.output, { total: 0, shown: 0 }, "without an out lamp nothing is counted apart");
});

test("asserts the census as its sum: shown + hidden + out = the files on disk, equal exactly while no file is shown or hidden wrongly", async () => {
    const withOutput = folder(["docs/x.md", "gadgets/a.ps1", "out/run/a.log"]);
    const lamps = { docs: filters.docs, tools: filters.tools, out: [set(["out/**"])] };
    const good = await engine.census(withOutput, new Set(["tools"]), lamps,["gadgets"]);
    assert.deepStrictEqual(good.sum, { shown: 1, hidden: 1, output: 1 });
    assert.strictEqual(good.disk, 3);
    const status = engine.statusLine(good, {});
    assert.strictEqual(status.text, "$(pass) 1+1+1=3");
    assert.deepStrictEqual([status.mood, status.accounted], ["clean", true]);
    const lying = await engine.census(withOutput, new Set(["tools"]), lamps,["gadgets", "docs"]);
    assert.strictEqual(engine.statusLine(lying, {}).text, "$(pass) 1+2+1≠3", "the doc is shown by the language and hidden by the entries");
    assert.strictEqual(engine.statusLine(lying, {}).accounted, false);
});

test("keeps the status within its budget: the sum always, the work's counts while they fit, red over wip over clean", () => {
    const tally = { disk: 2024, sum: { shown: 812, hidden: 1092, output: 120 }, wrong: [] };
    const facts = { a: { fault: "failed" }, b: { change: "unstaged" }, c: { change: "unstaged" }, d: { change: "staged" } };
    const full = engine.statusLine(tally, facts);
    assert.strictEqual(full.text, "$(error) 812+1092+120=2024 · 1 red · 3 changed", "the staged count drops first to fit");
    assert.strictEqual(full.mood, "red");
    assert.ok(full.text.replace(/\$\([a-z-]+\)/g, "ii").length <= 48);
    assert.strictEqual(engine.statusLine(tally, { b: { change: "staged" } }).text, "$(git-compare) 812+1092+120=2024 · 1 changed · 1 staged");
    const view = { name: "catzc", lit: ["open", "code"], off: [], vetoed: [] };
    const changes = Object.fromEntries([...Array(20).keys()].map((n) => [`f${n}`, { change: n < 2 ? "staged" : "unstaged" }]));
    assert.strictEqual(engine.statusLine(tally, changes, 48, view).text, "$(git-compare) catzc · 20 changed · 2 staged", "18 unstaged is implied");
    assert.strictEqual(engine.statusLine(tally, {}, 20).text, "$(pass) 812+1092+120=2024", "the sum is never dropped");
});

test("words the view when it fits: the repository less what is off and vetoed, or the lit lamps plus the rest, the shorter one", () => {
    const tally = { disk: 2024, sum: { shown: 812, hidden: 1092, output: 120 }, wrong: [] };
    const every = ["open", "code", "live", "configs", "tests", "docs"];
    const view = (off, vetoed = []) => ({ name: "catzc", lit: every.filter((l) => !off.includes(l) && !vetoed.includes(l)), off, vetoed });
    assert.strictEqual(engine.statusLine(tally, {}, 48, view([])).text, "$(pass) catzc", "every lamp lit is the repository");
    assert.strictEqual(engine.statusLine(tally, {}, 48, view(["tests", "docs"])).text, "$(pass) catzc − tests − docs");
    assert.strictEqual(engine.statusLine(tally, {}, 48, view(["docs"], ["tests"])).text, "$(pass) catzc − docs ∖ tests", "a veto takes its zone out");
    const most = view(["live", "configs", "tests", "docs"]);
    assert.strictEqual(engine.statusLine(tally, {}, 48, most).text, "$(pass) open + code + rest = catzc", "the lit lamps are the shorter word");
    const broken = { ...tally, wrong: ["docs/x.md"] };
    assert.strictEqual(engine.statusLine(broken, {}, 48, most).text, "$(pass) open + code + rest ≠ catzc");
    const crowded = { name: "catzc", lit: ["open"], off: ["code", "live", "configs", "tests", "docs", "generated", "pipelines"], vetoed: [] };
    assert.strictEqual(engine.statusLine(tally, {}, 48, crowded).text, "$(pass) open + rest = catzc");
});

test("reports a filter that went bananas, and a file no filter claims", async () => {
    const tally = await engine.census(root, new Set(["tests"]), filters,["gadgets"]);
    assert.deepStrictEqual([...tally.wrong].sort(), ["gadgets/a.ps1", "mods/Widget/tests/Get-Widget.Tests.ps1"]);
    const loose = folder(["loose.txt"]);
    assert.deepStrictEqual((await engine.census(loose, new Set(), filters,[])).unclaimed, ["loose.txt"]);
});

test("matches globs the way the repository reads them: ** any depth, * inside one segment", () => {
    const matches = (glob, place) => engine.globMatcher(glob)(place);
    assert.ok(matches("out/**", "out/a/b"));
    assert.ok(matches("pwsh/*/*.psd1", "pwsh/W/W.psd1"));
    assert.ok(!matches("pwsh/*/*.psd1", "pwsh/W/x/W.psd1"));
    assert.ok(matches("**/.gitkeep", ".gitkeep"));
    assert.ok(matches("docs/**/.assets/*.png", "docs/.assets/a.png"));
});

test("keeps every authored exclusion, drops the keys it added before, and never owns a key the settings already carry", () => {
    const result = engine.merge({ "**/tmp": true, "old/lamp": true, shared: true }, ["old/lamp"], ["shared", "new/lamp"]);
    assert.deepStrictEqual(Object.keys(result.next).sort(), ["**/tmp", "new/lamp", "shared"]);
    assert.deepStrictEqual(result.ours, ["new/lamp"]);
});

test("writes as few entries as the shown files allow: a dead folder whole, an extension no shown file shares as one glob, else the file", () => {
    const files = ["a/x.ps1", "a/y.ps1", "a/z.md", "b/c/w.ps1", "b/v.md", "b/u.yml", "d/t.yml", "LICENSE"];
    assert.deepStrictEqual(engine.hiddenEntries(files, ["a", "b", "b/c", "d"], ["a/z.md", "b/v.md", "d/t.yml"]), [
        "**/*.ps1",
        "**/c",
        "LICENSE",
        "b/**/*.yml",
    ]);
    assert.deepStrictEqual(
        engine.hiddenEntries(["a/z.md", "a/c/x.ps1", "b/c/y.md"], ["a", "a/c", "b", "b/c"], ["a/z.md", "b/c/y.md"]),
        ["a/c"],
        "a live folder is named c too, so the dead one is written itself",
    );
    assert.deepStrictEqual(engine.hiddenEntries(["a/x.ps1", "a/y.ps1"], ["a"], ["a/y.ps1"]), ["a/x.ps1"], "a script shows beside it");
});
