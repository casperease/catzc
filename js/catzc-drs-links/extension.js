// Opens a /docs/drs/... link in any file on click: a markdown link to a repository-root path under docs/drs/, resolved against the
// workspace folder, with its rule fragment kept.

const vscode = require("vscode");
const { drsLinks } = require("./links.js");

function activate(context) {
    const provider = {
        provideDocumentLinks(document) {
            const folder = vscode.workspace.getWorkspaceFolder(document.uri);
            if (!folder) return [];
            const text = document.getText();
            return drsLinks(text).map((link) => {
                const range = new vscode.Range(document.positionAt(link.start), document.positionAt(link.end));
                const target = vscode.Uri.joinPath(folder.uri, link.path).with({ fragment: link.fragment });
                const documentLink = new vscode.DocumentLink(range, target);
                documentLink.tooltip = `Open ${link.path}${link.fragment ? "#" + link.fragment : ""}`;
                return documentLink;
            });
        },
    };
    context.subscriptions.push(vscode.languages.registerDocumentLinkProvider({ scheme: "file" }, provider));
}

module.exports = { activate, deactivate() {} };
