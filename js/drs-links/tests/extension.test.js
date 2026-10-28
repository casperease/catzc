// The extension activated in a stub editor: the link provider it registers turns a /docs/drs/ link of an open file into a document
// link whose target is the decision record on disk, its rule fragment kept, so a click opens it.
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const os = require("os");
const path = require("path");

// The stub stands in for the editor's API, so its shapes are the editor's loose ones and typed any on purpose.
/** @type {{ selector?: any, provider?: any }} */
const registered = {};
/** @param {string} fsPath @param {string} [fragment] @returns {any} */
const uri = (fsPath, fragment = "") => ({
    scheme: "file",
    fsPath,
    fragment,
    with: (/** @type {{ fragment: string }} */ change) => uri(fsPath, change.fragment),
});
const vscode = {
    workspace: { getWorkspaceFolder: (/** @type {any} */ target) => target.folder },
    languages: {
        registerDocumentLinkProvider: (/** @type {any} */ selector, /** @type {any} */ provider) => {
            Object.assign(registered, { selector, provider });
            return { dispose() {} };
        },
    },
    Uri: { joinPath: (/** @type {any} */ base, /** @type {string} */ relative) => uri(path.join(base.fsPath, relative)) },
    /** @this {any} @param {number} start @param {number} end */
    Range: function (start, end) {
        this.start = start;
        this.end = end;
    },
    /** @this {any} @param {any} range @param {any} target */
    DocumentLink: function (range, target) {
        this.range = range;
        this.target = target;
    },
};
// Node resolves "vscode" for the extension through this hook; _load is node's internal loader, outside its published types.
const Module = /** @type {any} */ (require("module"));
const original = Module._load;
/** @this {any} @param {string} request @param {...any} rest */
Module._load = function (request, ...rest) {
    return request === "vscode" ? vscode : original.call(this, request, ...rest);
};

test("registers one link provider for every file, whose /docs/drs/ link opens the record on disk at its rule", () => {
    const root = fs.mkdtempSync(path.join(os.tmpdir(), "catzc-drs-links-"));
    const record = path.join(root, "docs", "drs", "design", "widgets.md");
    fs.mkdirSync(path.dirname(record), { recursive: true });
    fs.writeFileSync(record, "# Widgets\n");
    /** @type {{ dispose(): unknown }[]} */
    const subscriptions = [];
    require("../extension.js").activate(/** @type {any} */ ({ subscriptions }));
    assert.deepStrictEqual(registered.selector, { scheme: "file" }, "any file on disk, markdown and code alike");
    assert.strictEqual(subscriptions.length, 1, "the provider is disposed with the extension");

    const text = "See [the widget rule](/docs/drs/design/widgets.md#rule-widget-one) and [a gadget](../gadgets.md).";
    const document = {
        uri: { ...uri(path.join(root, "notes.md")), folder: { uri: uri(root) } },
        getText: () => text,
        positionAt: (/** @type {number} */ offset) => offset,
    };
    const links = registered.provider.provideDocumentLinks(document);
    assert.strictEqual(links.length, 1, "the relative link is the editor's own, not this provider's");
    const [link] = links;
    assert.strictEqual(text.slice(link.range.start, link.range.end), "/docs/drs/design/widgets.md#rule-widget-one");
    assert.strictEqual(link.target.fsPath, record);
    assert.ok(fs.existsSync(link.target.fsPath), "the click opens a file that is there");
    assert.strictEqual(link.target.fragment, "rule-widget-one", "the click lands on the rule");
    assert.strictEqual(link.tooltip, "Open docs/drs/design/widgets.md#rule-widget-one");
});

test("offers no link in a file outside any workspace folder", () => {
    require("../extension.js").activate(/** @type {any} */ ({ subscriptions: [] }));
    const document = { uri: { ...uri("/elsewhere/notes.md"), folder: undefined }, getText: () => "[a](/docs/drs/a.md)" };
    assert.deepStrictEqual(registered.provider.provideDocumentLinks(document), []);
});
