// Shades the lines a file changes against HEAD inside the editor, which the editor's own quick diff only marks in the gutter.
// Both diffs number their added lines in the working tree: HEAD..worktree gives every changed line, index..worktree the unstaged
// ones, so a line in the first and not the second is staged. A pure deletion has no line to shade; an untracked file has no diff.
// The colours are the contributed theme colours, set in workbench.colorCustomizations (vscode-settings.yml).

const vscode = require("vscode");
const path = require("path");
const { execFile } = require("child_process");
const { splitChanges } = require("./diff.js");

const staged = vscode.window.createTextEditorDecorationType({
    isWholeLine: true,
    backgroundColor: new vscode.ThemeColor("catzc.gitChanges.stagedBackground"),
});
const unstaged = vscode.window.createTextEditorDecorationType({
    isWholeLine: true,
    backgroundColor: new vscode.ThemeColor("catzc.gitChanges.unstagedBackground"),
});

/**
 * @param {string} cwd
 * @param {string[]} args
 * @returns {Promise<string | null>}
 */
function git(cwd, args) {
    return new Promise((resolve) => {
        execFile("git", args, { cwd, maxBuffer: 32 * 1024 * 1024, windowsHide: true }, (error, stdout) => resolve(error ? null : stdout));
    });
}

/** @param {import("vscode").TextEditor} editor */
async function shade(editor) {
    const document = editor.document;
    if (document.uri.scheme !== "file") return;
    const cwd = path.dirname(document.uri.fsPath);
    const file = path.basename(document.uri.fsPath);
    const options = ["diff", "-U0", "--no-color", "--no-ext-diff"];
    const [all, open] = await Promise.all([git(cwd, [...options, "HEAD", "--", file]), git(cwd, [...options, "--", file])]);
    if (all === null || open === null) {
        editor.setDecorations(staged, []);
        editor.setDecorations(unstaged, []);
        return;
    }
    const { staged: stagedLines, unstaged: unstagedLines } = splitChanges(all, open);
    const range = (/** @type {number} */ line) => document.lineAt(Math.min(line, document.lineCount - 1)).range;
    editor.setDecorations(staged, stagedLines.map(range));
    editor.setDecorations(unstaged, unstagedLines.map(range));
}

/** @type {ReturnType<typeof setTimeout> | undefined} */
let timer;
function refresh() {
    clearTimeout(timer);
    timer = setTimeout(() => vscode.window.visibleTextEditors.forEach(shade), 150);
}

/** @param {import("vscode").ExtensionContext} context */
function activate(context) {
    const watcher = vscode.workspace.createFileSystemWatcher("**/.git/{index,HEAD}");
    context.subscriptions.push(
        staged,
        unstaged,
        watcher,
        watcher.onDidChange(refresh),
        watcher.onDidCreate(refresh),
        vscode.window.onDidChangeVisibleTextEditors(refresh),
        vscode.workspace.onDidSaveTextDocument(refresh),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
}

module.exports = { activate, deactivate() {} };
