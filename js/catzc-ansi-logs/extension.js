// Renders the ANSI colours of a log under out/ in the editor: each escape is hidden and the text between escapes is painted in the
// terminal colour it names, so a coloured run log reads as it did in the terminal.

const vscode = require("vscode");
const { ansiSpans } = require("./ansi.js");

const hidden = vscode.window.createTextEditorDecorationType({ textDecoration: "none; font-size: 0; opacity: 0" });
const painted = new Map();

function paint(fg, bold) {
    const key = `${fg}|${bold}`;
    if (!painted.has(key)) {
        const colour = fg ? new vscode.ThemeColor(`terminal.ansi${fg[0].toUpperCase()}${fg.slice(1)}`) : undefined;
        painted.set(key, vscode.window.createTextEditorDecorationType({ color: colour, fontWeight: bold ? "bold" : undefined }));
    }
    return painted.get(key);
}

const isRunLog = (document) => document.uri.scheme === "file" && /[\/]out[\/].*\.log$/i.test(document.uri.fsPath);

function render(editor) {
    if (!editor || !isRunLog(editor.document)) return;
    const document = editor.document;
    const range = (from, to) => new vscode.Range(document.positionAt(from), document.positionAt(to));
    const { escapes, spans } = ansiSpans(document.getText());
    editor.setDecorations(hidden, escapes.map((e) => range(e.start, e.end)));
    const groups = new Map([...painted.values()].map((type) => [type, []]));
    for (const span of spans) {
        const type = paint(span.fg, span.bold);
        if (!groups.has(type)) groups.set(type, []);
        groups.get(type).push(range(span.start, span.end));
    }
    for (const [type, ranges] of groups) editor.setDecorations(type, ranges);
}

function activate(context) {
    vscode.window.visibleTextEditors.forEach(render);
    context.subscriptions.push(
        hidden,
        vscode.window.onDidChangeVisibleTextEditors((editors) => editors.forEach(render)),
        vscode.workspace.onDidChangeTextDocument((event) =>
            vscode.window.visibleTextEditors.filter((e) => e.document === event.document).forEach(render),
        ),
        { dispose: () => painted.forEach((type) => type.dispose()) },
    );
}

module.exports = { activate, deactivate() {} };
