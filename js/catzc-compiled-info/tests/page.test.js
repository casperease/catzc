// The note the compiled-types editor shows for a build against the current sources.
const test = require("node:test");
const assert = require("node:assert");

const { escape, builtHash, stateText, page } = require("../page.js");

test("reads the hash out of a build's file name and nothing else", () => {
    assert.strictEqual(builtHash("Catzc.Types.0a1b2c3d.dll"), "0a1b2c3d");
    assert.strictEqual(builtHash("Catzc.Types.0A1B2C3D.DLL"), "0A1B2C3D");
    assert.strictEqual(builtHash("Widget.Types.0a1b2c3d.dll"), undefined);
    assert.strictEqual(builtHash("Catzc.Types.0a1b2c.dll"), undefined);
});

test("escapes the three characters markup reads", () => {
    assert.strictEqual(escape("<a & b>"), "&lt;a &amp; b&gt;");
});

test("says the build is current when its hash equals the sources' hash, ignoring case", () => {
    assert.match(stateText("Catzc.Types.0A1B2C3D.dll", "0a1b2c3d"), /build of the current sources \(<code>0a1b2c3d<\/code>\)/);
});

test("names both hashes when they differ, and the file name when it holds no hash", () => {
    assert.match(stateText("Catzc.Types.11111111.dll", "22222222"), /hash to <code>22222222<\/code>; this build is <code>11111111<\/code>/);
    assert.match(stateText("widget.dll", "22222222"), /this build is <code>widget\.dll<\/code>/);
});

test("says the hash could not be read when the sources gave none", () => {
    assert.match(stateText("Catzc.Types.11111111.dll", null), /could not be read/);
});

test("the page shows the name, the state and the build record only when there is one", () => {
    const withInfo = page("Catzc.Types.11111111.dll", "11111111", "{ \"widget\": <1> }");
    assert.match(withInfo, /<h2>Catzc\.Types\.11111111\.dll<\/h2>/);
    assert.match(withInfo, /<pre>\{ "widget": &lt;1&gt; \}<\/pre>/);
    assert.doesNotMatch(page("Catzc.Types.11111111.dll", "11111111", ""), /Build record/);
});
