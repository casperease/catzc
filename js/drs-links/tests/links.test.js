// The /docs/drs/ links a text holds, and the ones it does not.
const test = require("node:test");
const assert = require("node:assert");

const { drsLinks } = require("../links.js");

test("finds a /docs/drs/ link with its rule fragment, covering the target inside the parentheses", () => {
    const text = "See [the widget rule](/docs/drs/design/widgets.md#rule-widget-one) here.";
    const [link] = drsLinks(text);
    assert.strictEqual(link.path, "docs/drs/design/widgets.md");
    assert.strictEqual(link.fragment, "rule-widget-one");
    assert.strictEqual(text.slice(link.start, link.end), "/docs/drs/design/widgets.md#rule-widget-one");
});

test("finds every link of a line, a link without a fragment included", () => {
    const links = drsLinks("[a](/docs/drs/a.md) and [b](/docs/drs/gadgets/b.md#x)");
    assert.deepStrictEqual(
        links.map((l) => [l.path, l.fragment]),
        [
            ["docs/drs/a.md", ""],
            ["docs/drs/gadgets/b.md", "x"],
        ],
    );
});

test("leaves a relative link, a link outside docs/drs and a bare path alone", () => {
    assert.deepStrictEqual(drsLinks("[a](../drs/a.md) [b](/docs/how-to/b.md) /docs/drs/c.md"), []);
});
