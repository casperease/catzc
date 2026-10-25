// The language lamps: a ticked language is a lamp after the filters, lang-<name>, its sets one include per extension; it lights, goes off
// and vetoes like a filter lamp, the census accounts for it, and the status words name it.
const test = require("node:test");
const assert = require("node:assert");

const { engine, set, filters, root } = require("./fixture.js");
const { languageSets } = require("../host.js");

const languages = {
    powershell: { tag: "pwsh", extensions: [".ps1"] },
    markdown: { tag: "md", extensions: [".md"] },
    widget: { tag: "wdg", extensions: [".wdg"] },
};
const withLanguages = (names) => ({ ...filters, ...languageSets(languages, names) });

test("makes a lamp of each ticked language only, after the filters in the languages' order, one include per extension", () => {
    const sets = withLanguages(["markdown", "powershell"]);
    assert.deepStrictEqual(Object.keys(sets).slice(-2), ["lang-powershell", "lang-markdown"]);
    assert.deepStrictEqual(sets["lang-powershell"], [set(["**/*.ps1"])]);
    assert.strictEqual(sets["lang-widget"], undefined, "an unticked language is no lamp");
    assert.deepStrictEqual(languageSets(languages, []), {});
});

test("shows a language's files while its lamp is lit, hides only what no lit lamp claims while it is off, and hides its whole zone when vetoed", () => {
    const sets = withLanguages(["powershell"]);
    const files = ["mods/Widget/Get-Widget.ps1", "gadgets/a.ps1", "docs/x.md"];
    const every = new Set(Object.keys(sets));
    const lit = (...off) => new Set([...every].filter((name) => !off.includes(name)));
    assert.deepStrictEqual(engine.evaluate(sets, lit(), files).shown, files, "every lamp lit shows everything");
    assert.deepStrictEqual(engine.evaluate(sets, lit("lang-powershell", "tools"), files).shown, [
        "mods/Widget/Get-Widget.ps1",
        "docs/x.md",
    ]);
    const vetoed = engine.evaluate(sets, lit("lang-powershell"), files, {}, ["lang-powershell"]);
    assert.deepStrictEqual(vetoed.shown, ["docs/x.md"], "a vetoed language takes out its files though code and tools are lit");
    assert.deepStrictEqual(engine.evaluate(sets, lit(), files).signatures["gadgets/a.ps1"], ["tools", "lang-powershell"]);
});

test("gives a language lamp its condition from the facts over its files, like any lamp", () => {
    const sets = withLanguages(["powershell", "markdown"]);
    const facts = { "gadgets/a.ps1": { change: "unstaged" } };
    const { conditions } = engine.evaluate(sets, new Set(Object.keys(sets)), [], facts);
    assert.strictEqual(conditions["lang-powershell"], "unstaged");
    assert.strictEqual(conditions["lang-markdown"], "committed");
});

test("accounts for every file with a language lamp off and with it vetoed: none against its lamps and none unclaimed", async () => {
    const sets = withLanguages(["powershell"]);
    for (const vetoed of [[], ["lang-powershell"]]) {
        const out = new Set(["lang-powershell"]);
        const globs = await engine.hiddenGlobs(root, out, sets, [], vetoed);
        const tally = await engine.census(root, out, sets, globs, [], vetoed);
        assert.deepStrictEqual(tally.wrong, [], `vetoed ${vetoed.length > 0}`);
        assert.deepStrictEqual(tally.unclaimed, []);
        assert.strictEqual(tally.shown + tally.sum.hidden, tally.total);
    }
});

test("names a language lamp in the status words by its lamp name, off and vetoed", () => {
    const tally = { sum: { shown: 3, hidden: 2, output: 0 }, disk: 5, wrong: [] };
    assert.match(
        engine.statusLine(tally, {}, 80, { name: "catzc", lit: ["code"], off: ["lang-python"], vetoed: [] }).text,
        /catzc − lang-python/,
    );
    assert.match(engine.statusLine(tally, {}, 80, { name: "catzc", lit: ["code"], off: [], vetoed: ["lang-go"] }).text, /catzc ∖ lang-go/);
});
