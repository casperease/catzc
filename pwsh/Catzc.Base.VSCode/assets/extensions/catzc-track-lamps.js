// A short row of filter lamps in the Explorer: one per aspect, and one language lamp with a typed list of languages.
// A lamp is lit (green) while what it covers is shown in the tree, and unlit while it filters that away; every lamp lit is the default and
// shows everything, as without the extension. What a lamp hides is rendered into the workspace settings: each aspect's cover
// (catzc.trackLamps.aspects, the fewest paths that hold exactly its files) and each language's extensions (catzc.trackLamps.languages).
// Hiding writes files.exclude at workspace scope, the only filter the Explorer has; the extension owns the keys it adds and nothing else,
// so an authored exclusion survives and a regenerated settings file is re-applied.

// The filtering itself is pure (hiddenGlobs, merge), so the tests drive it with node and no editor; vscode is required on activation only.

const fs = require("fs");
const path = require("path");

let vscode;
let log;

const OUT = "catzc.trackLamps.out";
const FIELD = "catzc.trackLamps.field";
const OWNED = "catzc.trackLamps.owned";
const LANGUAGE = "languages";

const config = () => vscode.workspace.getConfiguration("catzc.trackLamps");
const aspects = () => config().get("aspects") ?? {};
const languages = () => config().get("languages") ?? {};
const typed = (text) => (text ?? "").split(",").map((name) => name.trim()).filter(Boolean);

// The globs that hide what the unlit lamps cover: each unlit aspect's cover paths, folded upward where a folder holds nothing else, and
// each typed language's extensions while the language lamp is unlit.
function hiddenGlobs(root, out, field, covers, known) {
    const globs = new Set();
    for (const name of Object.keys(covers).filter((name) => out.has(name))) covers[name].forEach((place) => globs.add(place));
    // A folder whose every entry is hidden is hidden itself, so an unlit aspect leaves no empty parent behind.
    for (let grew = true; grew; ) {
        grew = false;
        for (const glob of [...globs]) {
            const parent = path.posix.dirname(glob);
            if (parent === "." || globs.has(parent)) continue;
            let entries;
            try {
                entries = fs.readdirSync(path.join(root, parent));
            } catch {
                continue;
            }
            if (entries.every((entry) => globs.has(`${parent}/${entry}`))) {
                entries.forEach((entry) => globs.delete(`${parent}/${entry}`));
                globs.add(parent);
                grew = true;
            }
        }
    }
    if (out.has(LANGUAGE)) {
        for (const name of typed(field)) (known[name] ?? []).forEach((extension) => globs.add(`**/*${extension}`));
    }
    return [...globs].sort();
}

// The next files.exclude: the current one without the keys the lamps added before, plus the wanted globs. A glob the settings already
// carry is theirs, never the lamps', so the lamps own only the keys they add.
function merge(current, owned, wanted) {
    const authored = { ...current };
    owned.forEach((glob) => delete authored[glob]);
    const ours = wanted.filter((glob) => !(glob in authored));
    const next = { ...authored };
    ours.forEach((glob) => (next[glob] = true));
    return { next, ours };
}

async function apply(context) {
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (!folder) {
        log.appendLine("apply: no workspace folder");
        return;
    }
    const out = new Set(context.workspaceState.get(OUT, []));
    const field = context.workspaceState.get(FIELD, "");
    const wanted = hiddenGlobs(folder.uri.fsPath, out, field, aspects(), languages());
    const files = vscode.workspace.getConfiguration("files", folder.uri);
    const current = files.inspect("exclude")?.workspaceValue ?? {};
    const { next, ours } = merge(current, context.workspaceState.get(OWNED, []), wanted);
    log.appendLine(`apply: unlit [${[...out].join(", ")}], field "${field}", ${wanted.length} globs wanted, ${ours.length} owned`);
    await context.workspaceState.update(OWNED, ours);
    if (JSON.stringify(next) !== JSON.stringify(current)) {
        await files.update("exclude", next, vscode.ConfigurationTarget.Workspace);
        log.appendLine(`apply: files.exclude written with ${Object.keys(next).length} keys`);
    }
}

function page(webview, out, field) {
    const nonce = [...Array(32)].map(() => Math.floor(Math.random() * 16).toString(16)).join("");
    const escape = (text) => String(text).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
    const covers = aspects();
    const known = languages();
    const unknown = typed(field).filter((name) => !(name in known));
    const lamp = (id, label, title) =>
        `<button class="lamp ${out.has(id) ? "unlit" : "lit"}" data-id="${escape(id)}" title="${escape(title)}"><span class="bulb"></span>${escape(label)}</button>`;
    const aspectLamps = Object.keys(covers).map((name) => lamp(name, name, `aspect ${name}: ${covers[name].length} paths; lit shows them, unlit hides them`));
    const languageTitle = unknown.length
        ? `unknown: ${unknown.join(", ")}; known: ${Object.keys(known).join(", ")}`
        : `comma-separated languages, hidden while the lamp is unlit; known: ${Object.keys(known).join(", ")}`;
    return `<!doctype html><html><head><meta charset="utf-8">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src ${webview.cspSource} 'unsafe-inline'; script-src 'nonce-${nonce}';">
<style>
body { padding: 4px 8px; font-family: var(--vscode-font-family); font-size: var(--vscode-font-size); }
.row { display: flex; flex-wrap: wrap; gap: 4px; align-items: center; }
.lamp { display: inline-flex; align-items: center; gap: 5px; padding: 1px 8px; border-radius: 10px; cursor: pointer; flex: none;
  border: 1px solid var(--vscode-panel-border); background: transparent; color: var(--vscode-descriptionForeground); font: inherit; }
.lamp .bulb { width: 8px; height: 8px; border-radius: 50%; background: var(--vscode-disabledForeground); }
.lamp.lit { color: var(--vscode-foreground); border-color: var(--vscode-charts-green); }
.lamp.lit .bulb { background: var(--vscode-charts-green); box-shadow: 0 0 6px var(--vscode-charts-green); }
.lamp:focus-visible { outline: 1px solid var(--vscode-focusBorder); }
.field { display: flex; gap: 4px; align-items: center; flex: 1 1 140px; min-width: 0; }
.field input { flex: 1; min-width: 0; font: inherit; padding: 1px 6px; color: var(--vscode-input-foreground);
  background: var(--vscode-input-background); border: 1px solid var(--vscode-input-border, transparent); border-radius: 2px; }
.field input.bad { border-color: var(--vscode-inputValidation-errorBorder); }
</style></head><body>
<div class="row">${aspectLamps.join("")}<span class="field">${lamp(LANGUAGE, "languages", languageTitle)}<input id="field" type="text" spellcheck="false"
 value="${escape(field)}" placeholder="markdown, yaml" title="${escape(languageTitle)}" class="${unknown.length ? "bad" : ""}"></span></div>
<script nonce="${nonce}">
const vscode = acquireVsCodeApi();
document.querySelectorAll(".lamp").forEach((lamp) => lamp.addEventListener("click", () => vscode.postMessage({ press: lamp.dataset.id })));
const field = document.getElementById("field");
const commit = () => vscode.postMessage({ field: field.value });
field.addEventListener("change", commit);
field.addEventListener("keydown", (event) => event.key === "Enter" && commit());
</script></body></html>`;
}

function activate(context) {
    vscode = require("vscode");
    log = vscode.window.createOutputChannel("Catzc track lamps");
    context.subscriptions.push(log);
    let view;
    const render = () => {
        if (view) view.webview.html = page(view.webview, new Set(context.workspaceState.get(OUT, [])), context.workspaceState.get(FIELD, ""));
    };
    // Every failure lands in the output channel; an unhandled rejection would vanish without a trace.
    const settle = async () => {
        try {
            await apply(context);
        } catch (error) {
            log.appendLine(`apply failed: ${error?.stack ?? error}`);
            vscode.window.showWarningMessage(`Catzc track lamps could not filter: ${error?.message ?? error}`);
        }
        render();
    };
    let timer;
    const refresh = () => {
        clearTimeout(timer);
        timer = setTimeout(settle, 200);
    };
    const receive = async ({ press, field }) => {
        if (press !== undefined) {
            const out = new Set(context.workspaceState.get(OUT, []));
            if (out.has(press)) out.delete(press);
            else out.add(press);
            await context.workspaceState.update(OUT, [...out]);
        }
        if (field !== undefined) await context.workspaceState.update(FIELD, field);
        await settle();
    };

    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider("catzc.trackLamps", {
            resolveWebviewView(webviewView) {
                view = webviewView;
                view.webview.options = { enableScripts: true };
                view.webview.onDidReceiveMessage(receive);
                view.onDidDispose(() => (view = undefined));
                render();
            },
        }),
        vscode.workspace.onDidChangeConfiguration((event) => {
            if (event.affectsConfiguration("catzc.trackLamps") || event.affectsConfiguration("files.exclude")) refresh();
        }),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
}

module.exports = { activate, deactivate() {}, hiddenGlobs, merge, typed };
