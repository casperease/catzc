/*
---
catzc:
  immutable:
    with_body_sha: "97d9e90c0d62"
---
*/

// Records every save the editor makes in a catzc checkout, so the listen mode can tell the editor's changes from an agent's.
// One JSON line per save, appended to out/editor-saves.jsonl (the path WriteLedger.EditorLedger names): the time, the repository-relative
// path, and the content hash the listener computes, SHA-256 of the bytes with every CR removed. A workspace without importer.ps1 at
// its root is no catzc checkout and records nothing; out/ itself is never recorded.

const vscode = require("vscode");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

function record(document) {
    if (document.uri.scheme !== "file") return;
    const folder = vscode.workspace.getWorkspaceFolder(document.uri);
    if (!folder) return;
    const root = folder.uri.fsPath;
    if (!fs.existsSync(path.join(root, "importer.ps1"))) return;
    const relative = path.relative(root, document.uri.fsPath).split(path.sep).join("/");
    if (relative.startsWith("..") || relative.startsWith("out/")) return;

    fs.readFile(document.uri.fsPath, (error, bytes) => {
        if (error) return;
        const hash = crypto
            .createHash("sha256")
            .update(bytes.filter((b) => b !== 13))
            .digest("hex");
        const line = JSON.stringify({ at: new Date().toISOString(), event: "save", path: relative, hash }) + "\n";
        const out = path.join(root, "out");
        fs.mkdir(out, { recursive: true }, () => fs.appendFile(path.join(out, "editor-saves.jsonl"), line, () => {}));
    });
}

function activate(context) {
    context.subscriptions.push(vscode.workspace.onDidSaveTextDocument(record));
}

module.exports = { activate, deactivate() {} };
