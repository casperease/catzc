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
const GENERATED = "generated";
const LAMPS = ["code", "tests", "tools", GENERATED, LANGUAGE];

const config = () => vscode.workspace.getConfiguration("catzc.trackLamps");
const aspects = () => config().get("aspects") ?? {};
const tools = () => config().get("tools") ?? [];
const generatedTargets = () => config().get("generated") ?? [];
const languages = () => config().get("languages") ?? {};
const typed = (text) => (text ?? "").split(",").map((name) => name.trim()).filter(Boolean);

// A path test for a glob, read the way the repository's GlobPattern reads one: '/'-separated segments, '**' a whole segment standing for
// any depth, '*' and '?' inside one segment only.
function globMatcher(glob) {
    const segments = glob.split("/").map((segment) =>
        segment === "**" ? null : new RegExp(`^${segment.replace(/[.+^${}()|[\]\\]/g, "\\$&").replace(/\*/g, "[^/]*").replace(/\?/g, "[^/]")}$`),
    );
    const from = (at, parts, index) => {
        for (; at < segments.length; at++, index++) {
            if (segments[at] === null) {
                if (at === segments.length - 1) return true;
                for (let skip = index; skip <= parts.length; skip++) if (from(at + 1, parts, skip)) return true;
                return false;
            }
            if (index >= parts.length || !segments[at].test(parts[index])) return false;
        }
        return index === parts.length;
    };
    return (place) => from(0, place.split("/"), 0);
}

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
// lamp is unlit, everything else while the tests lamp is unlit, each typed language's extensions while the language lamp is unlit, and
// every generated target while the generated lamp is unlit, whichever other lamp holds it: generated is the top-most filter.
// While any lamp is unlit, a dead folder (one with no shown file anywhere inside, emptied by the lamps or empty on disk) leaves the tree
// too, as its topmost dead folder.
function hiddenGlobs(root, out, field, covers, known, tools = [], generated = []) {
    const places = new Set();
    const live = covers.live ?? [];
    if (out.has("code")) live.forEach((place) => places.add(place));
    if (out.has("tools")) tools.forEach((place) => places.add(place));
    if (out.has("tests")) rest(root, [...live, ...tools]).forEach((place) => places.add(place));
    const extensions = out.has(LANGUAGE) ? typed(field).flatMap((name) => known[name] ?? []) : [];
    const patterns = out.has(GENERATED) ? generated : [];
    if (places.size === 0 && extensions.length === 0 && patterns.length === 0) return [];

    const matchers = patterns.map(globMatcher);
    const hiddenFile = (name, place) => extensions.some((extension) => name.endsWith(extension)) || matchers.some((matches) => matches(place));
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
            } else if (!hiddenFile(entry.name, place)) any = true;
        }
        if (any || folder === ".") dead.push(...deadHere);
        return any;
    };
    shows(".");

    const globs = new Set(dead);
    for (const place of places) if (!dead.some((folder) => place.startsWith(folder + "/"))) globs.add(place);
    extensions.forEach((extension) => globs.add(`**/*${extension}`));
    patterns.forEach((pattern) => globs.add(pattern));
    return [...globs].sort();
}

// Every file on disk accounted for: each is classified on its own (code when a live path holds it, tools when a tool path does, tests
// otherwise) and must be hidden by the globs exactly when its lamp, or the language lamp over its extension, is off. Returns the totals,
// the files the tree shows, the files per lamp, and the files whose visibility breaks that rule.
function census(root, out, field, covers, known, tools, globs, generated = []) {
    const live = new Set(covers.live ?? []);
    const toolSet = new Set(tools);
    const hiddenPlaces = new Set(globs.filter((glob) => !/[*?]/.test(glob)));
    const hiddenMatchers = globs.filter((glob) => /[*?]/.test(glob)).map(globMatcher);
    const generatedMatchers = generated.map(globMatcher);
    const extensions = out.has(LANGUAGE) ? typed(field).flatMap((name) => known[name] ?? []) : [];
    const holds = (set, place) => {
        for (let at = place; at !== "."; at = path.posix.dirname(at)) if (set.has(at)) return true;
        return false;
    };
    const result = { total: 0, shown: 0, lamps: { code: 0, tests: 0, tools: 0 }, generated: 0, wrong: [] };
    const walk = (folder) => {
        let entries;
        try {
            entries = fs.readdirSync(path.join(root, folder), { withFileTypes: true });
        } catch {
            return;
        }
        for (const entry of entries) {
            const place = folder === "." ? entry.name : `${folder}/${entry.name}`;
            if (place === ".git") continue;
            if (entry.isDirectory()) {
                walk(place);
                continue;
            }
            const lamp = holds(live, place) ? "code" : holds(toolSet, place) ? "tools" : "tests";
            const isGenerated = generatedMatchers.some((matches) => matches(place));
            const expected =
                out.has(lamp) || extensions.some((extension) => entry.name.endsWith(extension)) || (out.has(GENERATED) && isGenerated);
            const hidden = holds(hiddenPlaces, place) || hiddenMatchers.some((matches) => matches(place));
            result.total++;
            result.lamps[lamp]++;
            if (isGenerated) result.generated++;
            if (!hidden) result.shown++;
            if (hidden !== expected) result.wrong.push(place);
        }
    };
    walk(".");
    return result;
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

// The files.exclude the lamps wrote last, so the settings change their own write raises is not taken for a new one.
let written;

async function apply(context) {
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (!folder) {
        log.appendLine("apply: no workspace folder");
        return undefined;
    }
    const root = folder.uri.fsPath;
    const out = new Set(context.workspaceState.get(OUT, []));
    const field = context.workspaceState.get(FIELD, "");
    const wanted = hiddenGlobs(root, out, field, aspects(), languages(), tools(), generatedTargets());
    const files = vscode.workspace.getConfiguration("files", folder.uri);
    const current = files.inspect("exclude")?.workspaceValue ?? {};
    const { next, ours } = merge(current, context.workspaceState.get(OWNED, []), wanted);
    log.appendLine(`apply: unlit [${[...out].join(", ")}], field "${field}", ${wanted.length} globs wanted, ${ours.length} owned`);
    await context.workspaceState.update(OWNED, ours);
    written = JSON.stringify(next);
    if (written !== JSON.stringify(current)) {
        await files.update("exclude", next, vscode.ConfigurationTarget.Workspace);
        log.appendLine(`apply: files.exclude written with ${Object.keys(next).length} keys`);
    }
    return { root, out, field, wanted };
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
    // The counter: shown/total files on disk, green while every file is hidden exactly when its lamp is off, red with the count when not.
    const counter = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    counter.command = "catzc.lamps.showLog";
    counter.text = "$(sync~spin) counting files";
    counter.show();
    context.subscriptions.push(counter, vscode.commands.registerCommand("catzc.lamps.showLog", () => log.show()));
    const count = (applied) => {
        if (!applied) return;
        const { root, out, field, wanted } = applied;
        const tally = census(root, out, field, aspects(), languages(), tools(), wanted, generatedTargets());
        const lamps = Object.entries(tally.lamps).map(([lamp, files]) => `${lamp} ${files}${out.has(lamp) ? " (hidden)" : ""}`);
        lamps.push(`generated ${tally.generated} of them${out.has(GENERATED) ? " (hidden)" : ""}`);
        if (tally.wrong.length === 0) {
            counter.text = `$(pass) ${tally.shown}/${tally.total} · everything is accounted for`;
            counter.color = "#3fb950";
            counter.tooltip = `Catzc lamps: ${tally.shown} of ${tally.total} files shown, every file hidden exactly when its lamp is off.\n${lamps.join(", ")}`;
        } else {
            counter.text = `$(warning) ${tally.shown}/${tally.total} · a filter went bananas (${tally.wrong.length})`;
            counter.color = "#f85149";
            counter.tooltip = `Catzc lamps: ${tally.wrong.length} files shown or hidden against their lamp, e.g. ${tally.wrong.slice(0, 5).join(", ")}\nClick for the log.`;
        }
        log.appendLine(`census: ${tally.shown}/${tally.total} shown; ${lamps.join(", ")}; ${tally.wrong.length} against their lamp${tally.wrong.length ? ": " + tally.wrong.slice(0, 20).join(", ") : ""}`);
    };
    // Every failure lands in the output channel; an unhandled rejection would vanish without a trace.
    const settle = async () => {
        try {
            const applied = await apply(context);
            setTimeout(() => {
                try {
                    count(applied);
                } catch (error) {
                    log.appendLine(`census failed: ${error?.stack ?? error}`);
                }
            }, 0);
        } catch (error) {
            log.appendLine(`apply failed: ${error?.stack ?? error}`);
            vscode.window.showWarningMessage(`Catzc track lamps could not filter: ${error?.message ?? error}`);
        }
        await show();
    };
    // A click switches the icon at once, then filters; the count follows.
    const turn = async (lamp, unlit) => {
        const out = new Set(context.workspaceState.get(OUT, []));
        if (unlit) out.add(lamp);
        else out.delete(lamp);
        await context.workspaceState.update(OUT, [...out]);
        await show();
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
            if (event.affectsConfiguration("catzc.trackLamps")) return refresh();
            if (!event.affectsConfiguration("files.exclude")) return;
            // The lamps' own write echoes back as a change; only a change made elsewhere (a regenerated settings file) is re-applied.
            const folder = vscode.workspace.workspaceFolders?.[0];
            const now = JSON.stringify(vscode.workspace.getConfiguration("files", folder?.uri).inspect("exclude")?.workspaceValue ?? {});
            if (now !== written) refresh();
        }),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
}

module.exports = { activate, deactivate() {}, census, globMatcher, hiddenGlobs, merge, rest, typed };
