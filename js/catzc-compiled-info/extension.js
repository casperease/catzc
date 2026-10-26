// A read-only editor for the committed pwsh/.compiled/Catzc.Types.<hash>.dll: a short note instead of the binary screen.
// The sources' hash comes from the loader's one measure, Get-CombinedTypeHash, through the pwsh on PATH; this file carries no copy of
// the algorithm ([ADR-PWSH-TYPES-ONEINSTANCEPERSESSION](/docs/drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-oneinstancepersession)).

const vscode = require("vscode");
const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");
const { escape, page } = require("./page.js");

/**
 * @param {string} modulesRoot
 * @returns {Promise<string | null>}
 */
function sourcesHash(modulesRoot) {
    const loader = path.join(modulesRoot, ".internal", "Catzc.Internal.Loader.psm1");
    const command =
        `Import-Module '${loader}'; Import-InternalModule Vendor; Import-InternalModule Types; ` +
        `[Console]::Out.Write((Get-CombinedTypeHash '${modulesRoot}').CombinedHash)`;
    return new Promise((resolve) => {
        execFile("pwsh", ["-NoProfile", "-NonInteractive", "-Command", command], { windowsHide: true, timeout: 30000 }, (error, stdout) =>
            resolve(error ? null : stdout.trim().toLowerCase()),
        );
    });
}

/**
 * @param {string} file
 * @returns {Promise<string>}
 */
async function render(file) {
    const name = path.basename(file);
    const current = await sourcesHash(path.dirname(path.dirname(file)));
    const sidecar = file.replace(/\.dll$/i, ".json");
    const info = fs.existsSync(sidecar) ? fs.readFileSync(sidecar, "utf8") : "";
    return page(name, current, info);
}

/** @param {import("vscode").ExtensionContext} context */
function activate(context) {
    context.subscriptions.push(
        vscode.window.registerCustomEditorProvider(
            "catzc.compiledInfo",
            {
                openCustomDocument: (uri) => ({ uri, dispose() {} }),
                async resolveCustomEditor(document, panel) {
                    panel.webview.html = "<body><p>Reading the build…</p></body>";
                    try {
                        panel.webview.html = await render(document.uri.fsPath);
                    } catch (error) {
                        panel.webview.html = `<body><p>Could not read the build: ${escape(String(error))}</p></body>`;
                    }
                },
            },
            { supportsMultipleEditorsPerDocument: true },
        ),
    );
}

module.exports = { activate };
