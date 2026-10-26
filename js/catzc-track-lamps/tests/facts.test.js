// The facts the editor feeds the lamps: changes from git, faults from the diagnostics, remembered Errors, and test-result markers.
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const path = require("path");

const { engine, set, folder } = require("./fixture.js");

const repository = "/widget-repo";
const uri = (place) => ({ fsPath: `${repository}/${place}` });

test("reads the change facts from the git extension's state: staged for the index, unstaged for the rest, unstaged winning", () => {
    const change = (place) => ({ uri: uri(place) });
    const facts = engine.gitFacts(repository, {
        indexChanges: [change("mods/Widget/Get-Widget.ps1"), change("mods/Widget/README.md")],
        workingTreeChanges: [change("mods/Widget/README.md")],
        untrackedChanges: [change("gadgets/new.ps1")],
        mergeChanges: [],
    });
    assert.strictEqual(facts["mods/Widget/Get-Widget.ps1"].change, "staged");
    assert.strictEqual(facts["mods/Widget/README.md"].change, "unstaged", "a file staged and changed again shows its newest work");
    assert.strictEqual(facts["gadgets/new.ps1"].change, "unstaged");
    const outside = engine.gitFacts(repository, { indexChanges: [{ uri: { fsPath: "/elsewhere/a.ps1" } }] });
    assert.deepStrictEqual(Object.keys(outside), [], "a path outside the root is no fact");
});

test("reads a fault fact from an Error diagnostic only", () => {
    const facts = engine.diagnosticFacts(repository, [
        [uri("mods/Widget/Get-Widget.ps1"), [{ severity: 1 }, { severity: 0 }]],
        [uri("gadgets/a.ps1"), [{ severity: 1 }]],
    ]);
    assert.strictEqual(facts["mods/Widget/Get-Widget.ps1"].fault, "failed");
    assert.ok(!("gadgets/a.ps1" in facts), "a warning is no failure");
});

test("fails a file on a Warning from a linter its gate fails on, such as a Ruff finding, and on no other Warning", () => {
    const facts = engine.diagnosticFacts(repository, [
        [uri("gadgets/lint.py"), [{ severity: 1, source: "Ruff" }]],
        [uri("gadgets/hint.py"), [{ severity: 1, source: "Pylance" }]],
        [uri("gadgets/info.py"), [{ severity: 2, source: "Ruff" }]],
    ]);
    assert.strictEqual(facts["gadgets/lint.py"].fault, "failed", "Test-PythonLint fails on any Ruff finding, which the extension reports as a Warning");
    assert.ok(!("gadgets/hint.py" in facts), "a Warning from a source no gate fails on is no failure");
    assert.ok(!("gadgets/info.py" in facts), "an Information is no failure, whatever its source");
});

test("holds a file's Error while the diagnostics fall silent, so red wins on the open lamp after the active file changes", async () => {
    const root = folder(["mods/Widget/Get-Widget.ps1"]);
    const red = "mods/Widget/Get-Widget.ps1";
    const other = "gadgets/a.ps1";
    /** @type {(place: string, diagnostics: import("../facts.js").Diagnostic[]) => import("../facts.js").DiagnosticEntry} */
    const entry = (place, diagnostics) => [{ fsPath: `${root}/${place}` }, diagnostics];
    const error = { severity: 0, message: "bad", source: "bicep", range: { start: { line: 3, character: 1 }, end: { line: 3, character: 9 } } };
    let held = engine.heldFaults(root, {}, [entry(red, [error])], 1000);
    assert.strictEqual(held[red].seen, 1000);
    assert.strictEqual(held[red].diagnostics[0].message, "bad");
    assert.deepStrictEqual(held[red].diagnostics[0].range, [3, 1, 3, 9]);
    held = engine.heldFaults(root, held, [entry(red, [])], 2000);
    assert.strictEqual(held[red].seen, 1000, "silence, on the active file or off it, never releases a fault");
    held = engine.heldFaults(root, held, [], 3000);
    assert.strictEqual(held[red].seen, 1000, "a closed tab clears the language server's diagnostics, and the fault stays");
    assert.deepStrictEqual(engine.heldFaults(root, held, [entry(red, [{ severity: 1 }])], 4000), {}, "a non-error set means the Error is fixed");
    // A held place with no live Error is published again, marked as remembered; one the server reports again is left to it.
    assert.strictEqual(engine.remembering(root, held, [])[red][0].message, "bad");
    assert.deepStrictEqual(engine.remembering(root, held, [entry(red, [error])]), {}, "a live Error shows once");
    assert.strictEqual(
        Object.keys(engine.remembering(root, held, [entry(red, [{ severity: 1, source: "PSScriptAnalyzer" }])])).length,
        1,
        "a failure only a Warning reports is published as an Error, so the editor paints it red, not gold",
    );
    assert.strictEqual(engine.isRemembered({ source: "bicep · remembered" }), true);
    assert.strictEqual(engine.isRemembered({ source: "bicep" }), false);
    // A file changed on disk after its Error was seen lapses; an untouched one stays.
    const past = Date.now() - 5 * 60 * 1000;
    assert.deepStrictEqual(await engine.lapsedFaults(root, { [red]: { seen: past, diagnostics: [] } }), {}, "the file is newer than the Error");
    const future = Date.now() + 5 * 60 * 1000;
    assert.strictEqual((await engine.lapsedFaults(root, { [red]: { seen: future, diagnostics: [] } }))[red].seen, future, "the file is older than the Error");
    assert.deepStrictEqual(await engine.lapsedFaults(root, { "gone/a.ps1": { seen: future, diagnostics: [] } }), {}, "a deleted file has no fault");
    assert.deepStrictEqual(engine.errorPlaces(root, [entry(red, [{ severity: 0 }]), entry(other, [{ severity: 1 }])]), [red]);
    // The held fact makes the open lamp failed over an unstaged active file.
    const facts = { [red]: { fault: "failed" }, [other]: { change: "unstaged" } };
    assert.strictEqual(engine.evaluate({ open: [set([red, other])] }, new Set(["open"]), [], facts).conditions.open, "failed");
});

test("reads a fresh test-result marker as a failed test file, and lapses one older than the tested module", async () => {
    const tested = "mods/Widget/tests/Get-Widget.Tests.ps1";
    const root = folder([tested, "mods/Widget/Get-Widget.ps1", `out/test-results/${tested}.failed`]);
    const past = new Date(Date.now() - 10 * 60 * 1000);
    for (const file of [tested, "mods/Widget/Get-Widget.ps1"]) fs.utimesSync(path.join(root, file), past, past);
    assert.strictEqual(engine.testedModule(tested), "mods/Widget");
    assert.strictEqual((await engine.markerFacts(root))[tested].fault, "failed");
    const later = new Date(Date.now() + 5 * 60 * 1000);
    fs.utimesSync(path.join(root, "mods/Widget/Get-Widget.ps1"), later, later);
    assert.deepStrictEqual(Object.keys(await engine.markerFacts(root)), [], "the module changed after the run, so the marker lapses");
    assert.deepStrictEqual(Object.keys(await engine.markerFacts(folder())), []);
});
