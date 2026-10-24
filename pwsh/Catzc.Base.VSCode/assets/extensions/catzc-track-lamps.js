// Filter lamps in the Explorer's title row: one per repository filter (filters.yml, rendered into catzc.trackLamps.filters by the root
// config generator) and a language lamp over a typed list of languages. Filters may claim the same file; a file shows while every filter
// claiming it is lit (hide wins), so an unlit lamp hides exactly what its filter claims and never reveals anything. Every lamp lit is the
// default and shows everything, as without the extension.
// Each lamp is two commands, its lit and its unlit icon, and the context key catzc.lamps.out.<lamp> picks which one the title row shows.
// Hiding writes files.exclude at workspace scope, the only filter the Explorer has; the extension owns the keys it adds and nothing else,
// so an authored exclusion survives and a regenerated settings file is re-applied. The counter in the status bar re-checks every file
// on disk against what was written, and counts the files per membership signature (the set of filters claiming a file).
// The filtering itself is pure (hiddenGlobs, census, merge), so the tests drive it with node and no editor; vscode is required on
// activation only. On Windows paths compare without case, as the file system does.

const fs = require("fs");
const path = require("path");

let vscode;
let log;

const OUT = "catzc.trackLamps.out";
const FIELD = "catzc.trackLamps.field";
const OWNED = "catzc.trackLamps.owned";
const LANGUAGE = "languages";
const FOLD = process.platform === "win32";

const config = () => vscode.workspace.getConfiguration("catzc.trackLamps");
const filters = () => config().get("filters") ?? {};
const languages = () => config().get("languages") ?? {};
const typed = (text) => (text ?? "").split(",").map((name) => name.trim()).filter(Boolean);
const key = (text) => (FOLD ? text.toLowerCase() : text);
const isGlob = (entry) => /[*?]/.test(entry);

// A path test for a glob, read the way the repository's GlobPattern reads one: '/'-separated segments, '**' a whole segment standing for
// any depth, '*' and '?' inside one segment only. The glob's literal leading segments reject a path before any wildcard is tried, and a
// caller testing many globs passes the path's segments, split once.
function globMatcher(glob) {
    const flags = FOLD ? "i" : "";
    const raw = glob.split("/");
    const segments = raw.map((segment) =>
        segment === "**" ? null : new RegExp(`^${segment.replace(/[.+^${}()|[\]\\]/g, "\\$&").replace(/\*/g, "[^/]*").replace(/\?/g, "[^/]")}$`, flags),
    );
    const literal = [];
    for (const segment of raw) {
        if (isGlob(segment)) break;
        literal.push(key(segment));
    }
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
    return (place, parts = place.split("/")) => {
        for (let at = 0; at < literal.length; at++) if (key(parts[at] ?? "") !== literal[at]) return false;
        return from(0, parts, 0);
    };
}

// A claim test for a filter's sets: a set claims a path that one of its includes matches and none of its excludes does. Each include is
// filed under its first literal segment, so a path is tried only against the includes that can match it; one that opens with a wildcard
// is tried against every path.
function claimer(sets) {
    const buckets = new Map();
    const wild = [];
    for (const set of sets) {
        const excludes = (set.exclude ?? []).map(globMatcher);
        for (const include of set.include ?? []) {
            const entry = { matches: globMatcher(include), excludes };
            const first = include.split("/")[0];
            if (isGlob(first)) wild.push(entry);
            else {
                const at = key(first);
                if (!buckets.has(at)) buckets.set(at, []);
                buckets.get(at).push(entry);
            }
        }
    }
    const tries = (entries, place, parts) =>
        entries.some(({ matches, excludes }) => matches(place, parts) && !excludes.some((excluded) => excluded(place, parts)));
    return (place, parts = place.split("/")) => tries(buckets.get(key(parts[0])) ?? [], place, parts) || tries(wild, place, parts);
}

// A claim test for written entries: a path claims itself and what lies under it, a glob what it matches.
function entryClaimer(entries) {
    const places = new Set(entries.filter((entry) => !isGlob(entry)).map(key));
    const matchers = entries.filter(isGlob).map(globMatcher);
    return (place, parts) => {
        for (let at = key(place); at !== "."; at = path.posix.dirname(at)) if (places.has(at)) return true;
        return matchers.some((matches) => matches(place, parts));
    };
}

// The entries that hide what the unlit lamps cover, found by one walk of the disk: a file is hidden while any filter claiming it is unlit
// (hide wins) or the language lamp is unlit over its extension. A folder that shows no file is written whole (so a dead folder, emptied
// by the lamps or empty on disk, leaves the tree too); a hidden file inside a shown folder is written itself, in its on-disk spelling; a
// file hidden by its language alone rides on the language's glob.
async function hiddenGlobs(root, out, field, declared, known) {
    const unlit = Object.keys(declared).filter((name) => out.has(name));
    const extensions = out.has(LANGUAGE) ? typed(field).flatMap((name) => known[name] ?? []) : [];
    if (unlit.length === 0 && extensions.length === 0) return [];
    const hides = claimer(unlit.flatMap((name) => declared[name]));
    // Returns whether the folder shows a file, and the entries that hide what it does not show.
    const walk = async (folder) => {
        let found;
        try {
            found = await fs.promises.readdir(path.join(root, folder), { withFileTypes: true });
        } catch {
            return { shows: true, hidden: [] };
        }
        let shows = false;
        const hidden = [];
        for (const entry of found) {
            const place = folder === "." ? entry.name : `${folder}/${entry.name}`;
            if (place === ".git") continue;
            if (entry.isDirectory()) {
                const inner = await walk(place);
                if (inner.shows) {
                    shows = true;
                    hidden.push(...inner.hidden);
                } else hidden.push(place);
                continue;
            }
            if (hides(place)) hidden.push(place);
            else if (!extensions.some((extension) => key(entry.name).endsWith(key(extension)))) shows = true;
        }
        return { shows, hidden };
    };
    const top = await walk(".");
    const globs = new Set(top.hidden);
    extensions.forEach((extension) => globs.add(`**/*${extension}`));
    return [...globs].sort();
}

// Every file on disk accounted for: each file's membership signature (the filters claiming it) says whether it must be hidden (some
// claiming filter unlit, or the language lamp over its extension), and the written entries must hide exactly those. Returns the totals,
// the files shown, the files per signature, the files no filter claims, and the files whose visibility breaks the rule.
async function census(root, out, field, declared, known, globs) {
    const names = Object.keys(declared);
    const claims = names.map((name) => [name, claimer(declared[name])]);
    const written = entryClaimer(globs);
    const extensions = out.has(LANGUAGE) ? typed(field).flatMap((name) => known[name] ?? []) : [];
    const result = { total: 0, shown: 0, signatures: {}, unclaimed: [], wrong: [] };
    const walk = async (folder) => {
        let found;
        try {
            found = await fs.promises.readdir(path.join(root, folder), { withFileTypes: true });
        } catch {
            return;
        }
        for (const entry of found) {
            const place = folder === "." ? entry.name : `${folder}/${entry.name}`;
            if (place === ".git") continue;
            if (entry.isDirectory()) {
                await walk(place);
                continue;
            }
            const parts = place.split("/");
            const signature = claims.filter(([, claimed]) => claimed(place, parts)).map(([name]) => name);
            const expected = signature.some((name) => out.has(name)) || extensions.some((extension) => key(entry.name).endsWith(key(extension)));
            const hidden = written(place, parts);
            result.total++;
            const label = signature.length ? signature.join("+") : "(none)";
            result.signatures[label] = (result.signatures[label] ?? 0) + 1;
            if (signature.length === 0) result.unclaimed.push(place);
            if (!hidden) result.shown++;
            if (hidden !== expected) result.wrong.push(place);
        }
    };
    await walk(".");
    return result;
}

// The next files.exclude: the current one without the keys the lamps added before, plus the wanted entries. An entry the settings
// already carry is theirs, never the lamps', so the lamps own only the keys they add.
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
    const wanted = await hiddenGlobs(root, out, field, filters(), languages());
    const files = vscode.workspace.getConfiguration("files", folder.uri);
    const current = files.inspect("exclude")?.workspaceValue ?? {};
    const { next, ours } = merge(current, context.workspaceState.get(OWNED, []), wanted);
    log.appendLine(`apply: unlit [${[...out].join(", ")}], field "${field}", ${wanted.length} entries wanted, ${ours.length} owned`);
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
    const lamps = () => [...Object.keys(filters()), LANGUAGE];

    // The title row shows each lamp's lit or unlit icon by its context key.
    const show = async () => {
        const out = new Set(context.workspaceState.get(OUT, []));
        await Promise.all(lamps().map((lamp) => vscode.commands.executeCommand("setContext", `catzc.lamps.out.${lamp}`, out.has(lamp))));
    };
    // The counter: shown/total files on disk, green while every file is hidden exactly as its filters say, red with the count when not.
    const counter = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    counter.command = "catzc.lamps.showLog";
    counter.text = "$(sync~spin) counting files";
    counter.show();
    context.subscriptions.push(counter, vscode.commands.registerCommand("catzc.lamps.showLog", () => log.show()));
    const count = async (applied) => {
        if (!applied) return;
        const { root, out, field, wanted } = applied;
        const tally = await census(root, out, field, filters(), languages(), wanted);
        const matrix = Object.entries(tally.signatures)
            .sort((a, b) => b[1] - a[1])
            .map(([signature, files]) => `${signature}: ${files}`);
        const lit = lamps().filter((lamp) => lamp !== LANGUAGE).map((lamp) => `${lamp}${out.has(lamp) ? " (hidden)" : ""}`);
        if (tally.wrong.length === 0 && tally.unclaimed.length === 0) {
            counter.text = `$(pass) ${tally.shown}/${tally.total} · everything is accounted for`;
            counter.color = "#3fb950";
            counter.tooltip = `Catzc lamps: ${tally.shown} of ${tally.total} files shown, each hidden exactly when a filter claiming it is off.\nFilters: ${lit.join(", ")}\nFiles per signature:\n${matrix.join("\n")}`;
        } else {
            const problems = tally.wrong.length + tally.unclaimed.length;
            counter.text = `$(warning) ${tally.shown}/${tally.total} · a filter went bananas (${problems})`;
            counter.color = "#f85149";
            counter.tooltip = `Catzc lamps: ${tally.wrong.length} files shown or hidden against their filters, e.g. ${tally.wrong.slice(0, 3).join(", ")}; ${tally.unclaimed.length} files no filter claims, e.g. ${tally.unclaimed.slice(0, 3).join(", ")}\nClick for the log.`;
        }
        log.appendLine(
            `census: ${tally.shown}/${tally.total} shown; ${matrix.join(", ")}; ${tally.wrong.length} against their filters` +
                `${tally.wrong.length ? ": " + tally.wrong.slice(0, 20).join(", ") : ""}; ${tally.unclaimed.length} unclaimed` +
                `${tally.unclaimed.length ? ": " + tally.unclaimed.slice(0, 20).join(", ") : ""}`,
        );
    };
    // Every failure lands in the output channel; an unhandled rejection would vanish without a trace.
    const settle = async () => {
        try {
            const applied = await apply(context);
            // The count runs after the filter is in place, never delaying it; its failure is logged like any other.
            count(applied).catch((error) => log.appendLine(`census failed: ${error?.stack ?? error}`));
        } catch (error) {
            log.appendLine(`apply failed: ${error?.stack ?? error}`);
            const message = `Catzc track lamps could not filter: ${error?.message ?? error}`;
            // The editor refuses a settings write while settings.json is open with unsaved edits; saving it is the user's call, offered here.
            const dirty = vscode.workspace.textDocuments.find((document) => document.isDirty && /[\\/]\.vscode[\\/]settings\.json$/i.test(document.uri.fsPath));
            if (dirty) {
                vscode.window.showWarningMessage(message, "Save and filter").then(async (choice) => {
                    if (choice === "Save and filter" && (await dirty.save())) await settle();
                });
            } else {
                vscode.window.showWarningMessage(message);
            }
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

    // A command pair per lamp; the manifest declares the same names (a test holds it to filters.yml).
    for (const lamp of lamps()) {
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

module.exports = { activate, deactivate() {}, census, claimer, entryClaimer, globMatcher, hiddenGlobs, merge, typed };
