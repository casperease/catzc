/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/assets/extensions/catzc-git-changes.js
    folder: assets/extensions
    name: catzc-git-changes
    filetype: js
    kind: asset
    language: javascript
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
---
*/

// Shades the lines a file changes against HEAD inside the editor, which the editor's own quick diff only marks in the gutter.
// Both diffs number their added lines in the working tree: HEAD..worktree gives every changed line, index..worktree the unstaged
// ones, so a line in the first and not the second is staged. A pure deletion has no line to shade; an untracked file has no diff.
// The colours are the contributed theme colours, set in workbench.colorCustomizations (vscode-settings.yml).

const vscode = require("vscode");
const path = require("path");
const { execFile } = require("child_process");

const staged = vscode.window.createTextEditorDecorationType({
    isWholeLine: true,
    backgroundColor: new vscode.ThemeColor("catzc.gitChanges.stagedBackground"),
});
const unstaged = vscode.window.createTextEditorDecorationType({
    isWholeLine: true,
    backgroundColor: new vscode.ThemeColor("catzc.gitChanges.unstagedBackground"),
});

function git(cwd, args) {
    return new Promise((resolve) => {
        execFile("git", args, { cwd, maxBuffer: 32 * 1024 * 1024, windowsHide: true }, (error, stdout) => resolve(error ? null : stdout));
    });
}

function addedLines(diff) {
    const lines = new Set();
    for (const match of diff.matchAll(/^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@/gm)) {
        const start = Number(match[1]);
        const count = match[2] === undefined ? 1 : Number(match[2]);
        for (let line = start; line < start + count; line++) lines.add(line - 1);
    }
    return lines;
}

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
    const changed = addedLines(all);
    const pending = addedLines(open);
    const range = (line) => document.lineAt(Math.min(line, document.lineCount - 1)).range;
    editor.setDecorations(staged, [...changed].filter((line) => !pending.has(line)).map(range));
    editor.setDecorations(unstaged, [...pending].map(range));
}

let timer;
function refresh() {
    clearTimeout(timer);
    timer = setTimeout(() => vscode.window.visibleTextEditors.forEach(shade), 150);
}

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
