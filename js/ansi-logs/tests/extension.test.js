// The extension activated in a stub editor over a coloured log under out/: every escape is decorated hidden and every coloured run is
// painted in the terminal colour it names, while a log elsewhere is left as it is. Run as a script with an output path, it writes what
// the editor would show as an HTML page, the escapes dropped and the runs coloured, for a render to read.
// cspell:ignore mwidget mgadget mdone  -- fixture words run into the "m" that ends an escape
const test = require("node:test");
const assert = require("node:assert");
const fs = require("fs");
const path = require("path");

// The stub stands in for the editor's API, so its shapes are the editor's loose ones and typed any on purpose.
/** @typedef {{ options: any, dispose(): void }} Decoration */
/** @type {any[]} */
const visible = [];
const vscode = {
    window: {
        createTextEditorDecorationType: (/** @type {any} */ options) => ({ options, dispose() {} }),
        visibleTextEditors: visible,
        onDidChangeVisibleTextEditors: () => ({ dispose() {} }),
    },
    workspace: { onDidChangeTextDocument: () => ({ dispose() {} }) },
    /** @this {any} @param {string} id */
    ThemeColor: function (id) {
        this.id = id;
    },
    /** @this {any} @param {number} start @param {number} end */
    Range: function (start, end) {
        this.start = start;
        this.end = end;
    },
};
// Node resolves "vscode" for the extension through this hook; _load is node's internal loader, outside its published types.
const Module = /** @type {any} */ (require("module"));
const original = Module._load;
/** @this {any} @param {string} request @param {...any} rest */
Module._load = function (request, ...rest) {
    return request === "vscode" ? vscode : original.call(this, request, ...rest);
};

const LOG = "\x1b[1;92mwidget passed\x1b[0m\nplain line\n\x1b[31mgadget failed\x1b[0m and \x1b[33mone warning\x1b[39m\n";

// An editor of the text at the path, recording each decoration type's ranges as the extension sets them.
const editorOf = (/** @type {string} */ fsPath, /** @type {string} */ text) => {
    /** @type {Map<Decoration, { start: number, end: number }[]>} */
    const decorations = new Map();
    return {
        decorations,
        document: { uri: { scheme: "file", fsPath }, getText: () => text, positionAt: (/** @type {number} */ offset) => offset },
        setDecorations: (/** @type {Decoration} */ type, /** @type {any[]} */ ranges) => decorations.set(type, ranges),
    };
};

// What the editor shows of the text: the hidden ranges dropped, each painted run in its colour's theme id and weight.
const shown = (/** @type {ReturnType<typeof editorOf>} */ editor, /** @type {string} */ text) => {
    const hidden = [...editor.decorations].find(([type]) => /opacity: 0/.test(type.options.textDecoration ?? ""))?.[1] ?? [];
    /** @type {{ text: string, colour: string | null, bold: boolean }[]} */
    const runs = [];
    for (let at = 0; at < text.length; at++) {
        if (hidden.some((r) => at >= r.start && at < r.end)) continue;
        const painted = [...editor.decorations].find(
            ([type, ranges]) => !type.options.textDecoration && ranges.some((r) => at >= r.start && at < r.end),
        )?.[0];
        const colour = painted?.options.color?.id ?? null;
        const bold = painted?.options.fontWeight === "bold";
        const last = runs.at(-1);
        if (last && last.colour === colour && last.bold === bold) last.text += text[at];
        else runs.push({ text: text[at], colour, bold });
    }
    return runs;
};

const extension = require("../extension.js");
const runLog = editorOf(path.join("C:", "widgets", "out", "gadget", "run.log"), LOG);
const otherLog = editorOf(path.join("C:", "widgets", "gadget", "run.log"), LOG);
visible.push(runLog, otherLog);
extension.activate(/** @type {any} */ ({ subscriptions: [] }));

test("hides every escape of a log under out/ and paints each coloured run in the terminal colour it names", () => {
    const runs = shown(runLog, LOG);
    assert.ok(!runs.some((run) => run.text.includes("\x1b")), "no escape is left showing");
    assert.strictEqual(runs.map((run) => run.text).join(""), LOG.replace(/\x1b\[[0-9;]*m/g, ""), "every other character shows");
    assert.deepStrictEqual(
        runs.filter((run) => run.colour).map((run) => [run.text, run.colour, run.bold]),
        [
            ["widget passed", "terminal.ansiBrightGreen", true],
            ["gadget failed", "terminal.ansiRed", false],
            ["one warning", "terminal.ansiYellow", false],
        ],
    );
});

test("leaves a log outside an out folder undecorated", () => {
    assert.strictEqual(otherLog.decorations.size, 0);
});

// The page for the render: node extension.test.js <page.html> writes it; the test runner passes no such argument.
const page = process.argv[2];
if (page && page.endsWith(".html")) {
    /** @type {Record<string, string>} */
    const palette = {
        "terminal.ansiBrightGreen": "#23d18b",
        "terminal.ansiRed": "#cd3131",
        "terminal.ansiYellow": "#e5e510",
    };
    const escape = (/** @type {string} */ text) => text.replace(/&/g, "&amp;").replace(/</g, "&lt;");
    const body = shown(runLog, LOG)
        .map((run) =>
            run.colour
                ? `<span style="color:${palette[run.colour]};${run.bold ? "font-weight:bold" : ""}">${escape(run.text)}</span>`
                : escape(run.text),
        )
        .join("");
    const raw = escape(LOG.replace(/\x1b/g, "ESC"));
    fs.writeFileSync(
        page,
        `<body style="background:#1e1e1e;color:#cccccc;font:14px Consolas,monospace;margin:12px">` +
            `<div style="color:#888">raw file (ESC = the escape byte)</div><pre>${raw}</pre>` +
            `<div style="color:#888">as the extension decorates it</div><pre>${body}</pre></body>`,
    );
}
