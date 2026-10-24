// Filter lamps in the Explorer's title row: code (the live aspect), tools (the vendor configuration), tests (everything else), and a
// language lamp over a typed list of languages.
// A lamp is lit while what it covers is shown in the tree, and unlit while it filters that away; every lamp lit is the default and shows
// everything, as without the extension. Each lamp is two commands, its lit and its unlit icon, and the context key catzc.lamps.out.<lamp>
// picks which one the title row shows; the editor draws them, so no webview and no extra rows. What a lamp hides is rendered into the
// workspace settings: each aspect's cover (catzc.trackLamps.aspects, the fewest paths that hold exactly its files) and each language's
// extensions (catzc.trackLamps.languages). Hiding writes files.exclude at workspace scope, the only filter the Explorer has; the extension
// owns the keys it adds and nothing else, so an authored exclusion survives and a regenerated settings file is re-applied.
// The filtering itself is pure (hiddenGlobs, merge), so the tests drive it with node and no editor; vscode is required on activation only.

const fs = require("fs");
const path = require("path");

let vscode;
let log;

const OUT = "catzc.trackLamps.out";
const FIELD = "catzc.trackLamps.field";
const OWNED = "catzc.trackLamps.owned";
const LANGUAGE = "languages";
// The lamps the manifest draws in the title row, each with its putOut and light commands.
const LAMPS = ["code", "tests", "tools", LANGUAGE];

const config = () => vscode.workspace.getConfiguration("catzc.trackLamps");
const aspects = () => config().get("aspects") ?? {};
const tools = () => config().get("tools") ?? [];
const languages = () => config().get("languages") ?? {};
const typed = (text) => (text ?? "").split(",").map((name) => name.trim()).filter(Boolean);

// Everything on disk outside the kept paths: every entry that is no kept path and holds none, found by walking down only into folders
// that hold a kept path. It reaches what git does not track too (generated manifests, out/), which no tracked cover names.
function rest(root, keep) {
    const paths = new Set(keep);
    const holders = new Set();
    for (const place of keep) {
        for (let folder = path.posix.dirname(place); folder !== "."; folder = path.posix.dirname(folder)) holders.add(folder);
    }
    const globs = [];
    const walk = (folder) => {
        let entries;
        try {
            entries = fs.readdirSync(path.join(root, folder));
        } catch {
            return;
        }
        for (const entry of entries) {
            if (folder === "." && entry === ".git") continue;
            const place = folder === "." ? entry : `${folder}/${entry}`;
            if (paths.has(place)) continue;
            if (holders.has(place)) walk(place);
            else globs.push(place);
        }
    };
    walk(".");
    return globs;
}

// The globs that hide what the unlit lamps cover: the live cover while the code lamp is unlit, the vendor configuration while the tools
// lamp is unlit, everything else while the tests lamp is unlit, and each typed language's extensions while the language lamp is unlit.
// While any lamp is unlit, a dead folder (one with no shown file anywhere inside, emptied by the lamps or empty on disk) leaves the tree
// too, as its topmost dead folder.
function hiddenGlobs(root, out, field, covers, known, tools = []) {
    const places = new Set();
    const live = covers.live ?? [];
    if (out.has("code")) live.forEach((place) => places.add(place));
    if (out.has("tools")) tools.forEach((place) => places.add(place));
    if (out.has("tests")) rest(root, [...live, ...tools]).forEach((place) => places.add(place));
    const extensions = out.has(LANGUAGE) ? typed(field).flatMap((name) => known[name] ?? []) : [];
    if (places.size === 0 && extensions.length === 0) return [];

    const hiddenFile = (name) => extensions.some((extension) => name.endsWith(extension));
    const dead = [];
    // True when the folder shows at least one file; a folder that shows none is dead, and only the topmost of a dead chain is kept.
    const shows = (folder) => {
        let entries;
        try {
            entries = fs.readdirSync(path.join(root, folder), { withFileTypes: true });
        } catch {
            return true;
        }
        const deadHere = [];
        let any = false;
        for (const entry of entries) {
            const place = folder === "." ? entry.name : `${folder}/${entry.name}`;
            if (place === ".git" || places.has(place)) continue;
            if (entry.isDirectory()) {
                if (shows(place)) any = true;
                else deadHere.push(place);
            } else if (!hiddenFile(entry.name)) any = true;
        }
        if (any || folder === ".") dead.push(...deadHere);
        return any;
    };
    shows(".");

    const globs = new Set(dead);
    for (const place of places) if (!dead.some((folder) => place.startsWith(folder + "/"))) globs.add(place);
    extensions.forEach((extension) => globs.add(`**/*${extension}`));
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
    const wanted = hiddenGlobs(folder.uri.fsPath, out, field, aspects(), languages(), tools());
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

function activate(context) {
    vscode = require("vscode");
    log = vscode.window.createOutputChannel("Catzc track lamps");
    context.subscriptions.push(log);

    // The title row shows each lamp's lit or unlit icon by its context key.
    const show = async () => {
        const out = new Set(context.workspaceState.get(OUT, []));
        await Promise.all(LAMPS.map((lamp) => vscode.commands.executeCommand("setContext", `catzc.lamps.out.${lamp}`, out.has(lamp))));
    };
    // Every failure lands in the output channel; an unhandled rejection would vanish without a trace.
    const settle = async () => {
        try {
            await apply(context);
        } catch (error) {
            log.appendLine(`apply failed: ${error?.stack ?? error}`);
            vscode.window.showWarningMessage(`Catzc track lamps could not filter: ${error?.message ?? error}`);
        }
        await show();
    };
    const turn = async (lamp, unlit) => {
        const out = new Set(context.workspaceState.get(OUT, []));
        if (unlit) out.add(lamp);
        else out.delete(lamp);
        await context.workspaceState.update(OUT, [...out]);
        await settle();
    };
    // Putting the language lamp out asks which languages to hide, offering the last list; an empty answer keeps the lamp lit.
    const chooseLanguages = async () => {
        const known = Object.keys(languages());
        const answer = await vscode.window.showInputBox({
            title: "Languages to hide",
            prompt: `Comma-separated; known: ${known.join(", ")}`,
            value: context.workspaceState.get(FIELD, ""),
            validateInput: (text) => {
                const unknown = typed(text).filter((name) => !known.includes(name));
                return unknown.length ? `unknown: ${unknown.join(", ")}` : undefined;
            },
        });
        if (answer === undefined || typed(answer).length === 0) return;
        await context.workspaceState.update(FIELD, typed(answer).join(", "));
        await turn(LANGUAGE, true);
    };
    let timer;
    const refresh = () => {
        clearTimeout(timer);
        timer = setTimeout(settle, 200);
    };

    for (const lamp of LAMPS) {
        context.subscriptions.push(
            vscode.commands.registerCommand(`catzc.lamps.${lamp}.putOut`, lamp === LANGUAGE ? chooseLanguages : () => turn(lamp, true)),
            vscode.commands.registerCommand(`catzc.lamps.${lamp}.light`, () => turn(lamp, false)),
        );
    }
    context.subscriptions.push(
        vscode.workspace.onDidChangeConfiguration((event) => {
            if (event.affectsConfiguration("catzc.trackLamps") || event.affectsConfiguration("files.exclude")) refresh();
        }),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
}

module.exports = { activate, deactivate() {}, hiddenGlobs, merge, rest, typed };
