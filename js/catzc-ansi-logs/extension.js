// Renders the ANSI colours of a log under out/ in the editor: each escape is hidden and the text between escapes is painted in the
// terminal colour it names, so a coloured run log reads as it did in the terminal.

const vscode = require("vscode");
const { ansiSpans, isRunLogPath } = require("./ansi.js");

const hidden = vscode.window.createTextEditorDecorationType({ textDecoration: "none; font-size: 0; opacity: 0" });
/** @type {Map<string, vscode.TextEditorDecorationType>} */
const painted = new Map();

/**
 * @param {string | null} fg
 * @param {boolean} bold
 * @returns {vscode.TextEditorDecorationType}
 */
function paint(fg, bold) {
    const key = `${fg}|${bold}`;
    if (!painted.has(key)) {
        const colour = fg ? new vscode.ThemeColor(`terminal.ansi${fg[0].toUpperCase()}${fg.slice(1)}`) : undefined;
        painted.set(key, vscode.window.createTextEditorDecorationType({ color: colour, fontWeight: bold ? "bold" : undefined }));
    }
    return /** @type {vscode.TextEditorDecorationType} */ (painted.get(key));
}

/** @param {vscode.TextDocument} document */
const isRunLog = (document) => document.uri.scheme === "file" && isRunLogPath(document.uri.fsPath);

/** @param {vscode.TextEditor | undefined} editor */
function render(editor) {
    if (!editor || !isRunLog(editor.document)) return;
    const document = editor.document;
    /**
     * @param {number} from
     * @param {number} to
     */
    const range = (from, to) => new vscode.Range(document.positionAt(from), document.positionAt(to));
    const { escapes, spans } = ansiSpans(document.getText());
    editor.setDecorations(
        hidden,
        escapes.map((e) => range(e.start, e.end)),
    );
    /** @type {Map<vscode.TextEditorDecorationType, vscode.Range[]>} */
    const groups = new Map([...painted.values()].map((type) => [type, /** @type {vscode.Range[]} */ ([])]));
    for (const span of spans) {
        const type = paint(span.fg, span.bold);
        if (!groups.has(type)) groups.set(type, []);
        /** @type {vscode.Range[]} */ (groups.get(type)).push(range(span.start, span.end));
    }
    for (const [type, ranges] of groups) editor.setDecorations(type, ranges);
}

/** @param {vscode.ExtensionContext} context */
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
