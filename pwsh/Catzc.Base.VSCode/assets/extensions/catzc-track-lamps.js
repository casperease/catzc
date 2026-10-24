// A row of named lamps in the Explorer, one per track: a lit lamp shows its track's files, a dark one hides them.
// The tracks are rendered into the workspace settings from the variants config (catzc.trackLamps.tracks), and the tracks of a type
// named in catzc.trackLamps.groups share one lamp. Hiding writes files.exclude at workspace scope, the only filter the Explorer has;
// the extension owns the keys it adds and nothing else, so an authored exclusion survives and a regenerated settings file is re-lit.
// A lit place inside a dark one stays visible: the dark place is hidden entry by entry around it.

const vscode = require("vscode");
const fs = require("fs");
const path = require("path");

const DARK = "catzc.trackLamps.dark";
const OWNED = "catzc.trackLamps.owned";

function lamps() {
    const config = vscode.workspace.getConfiguration("catzc.trackLamps");
    const groups = config.get("groups") ?? {};
    const byName = new Map();
    for (const track of config.get("tracks") ?? []) {
        const name = groups[track.type] ?? track.name;
        const lamp = byName.get(name) ?? { name, tracks: [], places: [] };
        lamp.tracks.push(track.name);
        lamp.places.push(...(track.places ?? []));
        byName.set(name, lamp);
    }
    return [...byName.values()];
}

const isUnder = (place, parent) => place.startsWith(parent + "/");

function hiddenGlobs(root, list, dark) {
    const lit = list.filter((lamp) => !dark.has(lamp.name)).flatMap((lamp) => lamp.places);
    const globs = new Set();
    const hide = (place) => {
        const inner = lit.filter((other) => isUnder(other, place));
        if (inner.length === 0) {
            globs.add(place);
            return;
        }
        let entries = [];
        try {
            entries = fs.readdirSync(path.join(root, place));
        } catch {
            return;
        }
        for (const entry of entries) {
            const child = `${place}/${entry}`;
            if (inner.includes(child)) continue;
            if (inner.some((other) => isUnder(other, child))) hide(child);
            else globs.add(child);
        }
    };
    list.filter((lamp) => dark.has(lamp.name)).forEach((lamp) => lamp.places.forEach(hide));
    return [...globs];
}

async function apply(context) {
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (!folder) return;
    const dark = new Set(context.workspaceState.get(DARK, []));
    const wanted = hiddenGlobs(folder.uri.fsPath, lamps(), dark);
    const owned = context.workspaceState.get(OWNED, []);
    const files = vscode.workspace.getConfiguration("files", folder.uri);
    const current = files.inspect("exclude")?.workspaceValue ?? {};
    const authored = { ...current };
    owned.forEach((glob) => delete authored[glob]);
    // A glob the settings already carry is theirs, never the lamps'; the lamps own only the keys they add.
    const ours = wanted.filter((glob) => !(glob in authored));
    const next = { ...authored };
    ours.forEach((glob) => (next[glob] = true));
    await context.workspaceState.update(OWNED, ours);
    if (JSON.stringify(next) !== JSON.stringify(current)) {
        await files.update("exclude", next, vscode.ConfigurationTarget.Workspace);
    }
}

function page(webview, list, dark) {
    const nonce = [...Array(32)].map(() => Math.floor(Math.random() * 16).toString(16)).join("");
    const escape = (text) => text.replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
    const buttons = list
        .map((lamp) => {
            const state = dark.has(lamp.name) ? "dark" : "lit";
            const title = escape(`${lamp.tracks.join(", ")}: ${lamp.places.join(", ")} (click to toggle, alt+click to light only this)`);
            return `<button class="lamp ${state}" data-name="${escape(lamp.name)}" title="${title}"><span class="bulb"></span>${escape(lamp.name)}</button>`;
        })
        .join("");
    const empty = `<p class="empty">No tracks in the settings: render .vscode/settings.json with the root config generator.</p>`;
    return `<!doctype html><html><head><meta charset="utf-8">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src ${webview.cspSource} 'unsafe-inline'; script-src 'nonce-${nonce}';">
<style>
body { padding: 4px 8px; font-family: var(--vscode-font-family); font-size: var(--vscode-font-size); }
.row { display: flex; flex-wrap: wrap; gap: 4px; }
.lamp { display: inline-flex; align-items: center; gap: 5px; padding: 2px 8px; border-radius: 10px; cursor: pointer;
  border: 1px solid var(--vscode-panel-border); background: transparent; color: var(--vscode-descriptionForeground); font: inherit; }
.lamp .bulb { width: 8px; height: 8px; border-radius: 50%; background: var(--vscode-disabledForeground); }
.lamp.lit { color: var(--vscode-foreground); border-color: #f5e17a80; }
.lamp.lit .bulb { background: #f5e17a; box-shadow: 0 0 6px #f5e17a; }
.lamp:focus-visible { outline: 1px solid var(--vscode-focusBorder); }
.empty { color: var(--vscode-descriptionForeground); margin: 0; }
</style></head><body>
<div class="row">${list.length ? buttons : empty}</div>
<script nonce="${nonce}">
const vscode = acquireVsCodeApi();
document.querySelectorAll(".lamp").forEach((lamp) => lamp.addEventListener("click", (event) =>
  vscode.postMessage({ name: lamp.dataset.name, solo: event.altKey })));
</script></body></html>`;
}

function activate(context) {
    let view;
    const render = () => {
        if (view) view.webview.html = page(view.webview, lamps(), new Set(context.workspaceState.get(DARK, [])));
    };
    const setDark = async (names) => {
        await context.workspaceState.update(DARK, names);
        await apply(context);
        render();
    };
    let timer;
    const refresh = () => {
        clearTimeout(timer);
        timer = setTimeout(() => apply(context).then(render), 200);
    };

    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider("catzc.trackLamps", {
            resolveWebviewView(webviewView) {
                view = webviewView;
                view.webview.options = { enableScripts: true };
                view.webview.onDidReceiveMessage(({ name, solo }) => {
                    const dark = new Set(context.workspaceState.get(DARK, []));
                    if (solo) return setDark(lamps().map((lamp) => lamp.name).filter((other) => other !== name));
                    if (dark.has(name)) dark.delete(name);
                    else dark.add(name);
                    return setDark([...dark]);
                });
                view.onDidDispose(() => (view = undefined));
                render();
            },
        }),
        vscode.commands.registerCommand("catzc.trackLamps.lightAll", () => setDark([])),
        vscode.workspace.onDidChangeConfiguration((event) => {
            if (event.affectsConfiguration("catzc.trackLamps") || event.affectsConfiguration("files.exclude")) refresh();
        }),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
}

module.exports = { activate, deactivate() {} };
