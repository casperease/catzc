// A read-only editor for the committed pwsh/.compiled/Catzc.Types.<hash>.dll: a short note instead of the binary screen.
// The sources' hash comes from the loader's one measure, Get-CombinedTypeHash, through the pwsh on PATH; this file carries no copy of
// the algorithm ([ADR-PWSH-TYPES-ONEINSTANCEPERSESSION](/docs/drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-oneinstancepersession)).

const vscode = require("vscode");
const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");

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

const escape = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

async function render(file) {
    const name = path.basename(file);
    const built = (/^Catzc\.Types\.([0-9a-f]{8})\.dll$/i.exec(name) || [])[1];
    const current = await sourcesHash(path.dirname(path.dirname(file)));
    const sidecar = file.replace(/\.dll$/i, ".json");
    const info = fs.existsSync(sidecar) ? fs.readFileSync(sidecar, "utf8") : "";
    const state =
        current === null
            ? "The sources' hash could not be read: pwsh is not on PATH or the loader did not answer."
            : built !== undefined && built.toLowerCase() === current
              ? `This is the build of the current sources (<code>${escape(current)}</code>).`
              : `The sources hash to <code>${escape(current)}</code>; this build is <code>${escape(built || name)}</code>. ` +
                "A session that loaded this build keeps it until it exits; a new pwsh loads the current one.";
    return `<!doctype html><html><head><meta charset="utf-8"><style>
        body { font-family: var(--vscode-font-family); color: var(--vscode-foreground); padding: 1.5rem; max-width: 60rem; line-height: 1.5; }
        h2 { font-weight: 600; } code, pre { font-family: var(--vscode-editor-font-family); }
        pre { background: var(--vscode-textBlockQuote-background); padding: .75rem; overflow: auto; }
        .state { border-left: 4px solid var(--vscode-charts-blue); padding-left: .75rem; }
    </style></head><body>
        <h2>${escape(name)}</h2>
        <p><b>This is vendored.</b> A committed build of the Catzc type sources, written by the importer. Do not edit or rebuild it by hand.</p>
        <p class="state">${state}</p>
        ${info ? `<p>Build record:</p><pre>${escape(info)}</pre>` : ""}
    </body></html>`;
}

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
