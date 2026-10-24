// Filter lamps in the Explorer's title row, the editor's engine of the lamp language (DDR-FILTER): one lamp per repository filter
// (filters.yml, rendered into catzc.trackLamps.filters by the root config generator) and a languages lamp whose sets are the extensions of
// the languages typed in its field. The core, evaluate, is the language itself: the tree is the total union of the lit lamps (a file shows
// while any lit lamp claims it), a file no lamp claims shows and is unaccounted, and each lamp's condition is the highest fact over the
// files it claims, failed > unstaged > staged > committed, whether it is lit or not. Every lamp lit is the default and shows everything.
// The adapter feeds the core from what the editor already knows: the built-in git extension's changes, the Error diagnostics, and the
// test-result markers out/test-results/<test file>.failed (Invoke-TestFile), read by existence and timestamp only.
// The title row shows each lamp's icon by two context keys, catzc.lamps.out.<lamp> (the switch) and catzc.lamps.state.<lamp> (the
// condition). Hiding writes files.exclude at workspace scope, the only filter the Explorer has; the extension owns the keys it adds and
// nothing else, so an authored exclusion survives and a regenerated settings file is re-applied. The counter in the status bar re-checks
// every file on disk against what was written, and counts the files per membership signature (the set of lamps claiming a file).
// Everything but activate is pure or reads the disk only, so the tests drive it with node and no editor; vscode is required on activation
// only. On Windows paths compare without case, as the file system does.

const fs = require("fs");
const path = require("path");

let vscode;
let log;

const OUT = "catzc.trackLamps.out";
const FIELD = "catzc.trackLamps.field";
const OWNED = "catzc.trackLamps.owned";
const LANGUAGE = "languages";
const MARKERS = "out/test-results";
const FOLD = process.platform === "win32";
// The conditions by precedence, lowest first; a lamp shows the highest fact over the files it claims.
const CONDITIONS = ["committed", "staged", "unstaged", "failed"];

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

// Every lamp's sets: the declared filters' in their order, and the languages lamp's, one include per extension of each typed language
// (a language it does not know adds nothing).
function lampSets(declared, field, known) {
    const extensions = typed(field).flatMap((name) => known[name] ?? []);
    return { ...declared, [LANGUAGE]: [{ include: extensions.map((extension) => `**/*${extension}`), exclude: [] }] };
}

// The lamp language. sets: each lamp's sets; lit: the lamps on; files: the paths on disk; facts: path -> { change, fault }, where change
// is none, staged or unstaged and fault none or failed. Returns the files shown (the total union: any lit lamp claims it, or no lamp
// does), the files no lamp claims, each file's signature (the lamps claiming it, in lamp order), and each lamp's condition, the highest
// fact over the files it claims by the one precedence. A fact's path need not be on disk (a deleted file is a change), and the switch
// never touches a condition.
function evaluate(sets, lit, files, facts = {}) {
    const names = Object.keys(sets);
    const claims = names.map((name) => [name, claimer(sets[name])]);
    const signatureOf = (place) => {
        const parts = place.split("/");
        return claims.filter(([, claimed]) => claimed(place, parts)).map(([name]) => name);
    };
    const shown = [];
    const unaccounted = [];
    const signatures = {};
    for (const place of files) {
        const signature = signatureOf(place);
        signatures[place] = signature;
        if (signature.length === 0) unaccounted.push(place);
        if (signature.length === 0 || signature.some((name) => lit.has(name))) shown.push(place);
    }
    const rank = Object.fromEntries(names.map((name) => [name, 0]));
    for (const [place, fact] of Object.entries(facts)) {
        const level = fact?.fault === "failed" ? 3 : fact?.change === "unstaged" ? 2 : fact?.change === "staged" ? 1 : 0;
        if (level === 0) continue;
        for (const name of signatures[place] ?? signatureOf(place)) rank[name] = Math.max(rank[name], level);
    }
    const conditions = Object.fromEntries(names.map((name) => [name, CONDITIONS[rank[name]]]));
    return { shown, unaccounted, signatures, conditions };
}

// The files and the folders on disk, '/'-separated from the root, in one walk; .git is no part of the tree.
async function walkDisk(root) {
    const files = [];
    const folders = [];
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
                folders.push(place);
                await walk(place);
            } else files.push(place);
        }
    };
    await walk(".");
    return { files, folders };
}

// The entries that hide what the tree does not show: a folder that shows no file is written whole, as its topmost such folder (so a dead
// folder, emptied by the lamps or empty on disk, leaves the tree too), and a hidden file inside a shown folder is written itself, in its
// on-disk spelling.
function hiddenEntries(files, folders, shown) {
    const live = new Set();
    for (const place of shown) for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) live.add(at);
    const showing = new Set(shown);
    const topmostDead = (place) => {
        let dead;
        for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) if (!live.has(at)) dead = at;
        return dead;
    };
    const entries = new Set();
    for (const place of files) if (!showing.has(place)) entries.add(topmostDead(place) ?? place);
    for (const place of folders) if (!live.has(place)) entries.add(topmostDead(place) ?? place);
    return [...entries].sort();
}

// The entries for the unlit lamps, from one walk of the disk: out holds the unlit lamps, field the languages typed for the languages lamp.
// Every lamp lit writes nothing, as without the extension.
async function hiddenGlobs(root, out, field, declared, known) {
    const sets = lampSets(declared, field, known);
    const lit = new Set(Object.keys(sets).filter((name) => !out.has(name)));
    if (lit.size === Object.keys(sets).length) return [];
    const { files, folders } = await walkDisk(root);
    return hiddenEntries(files, folders, evaluate(sets, lit, files).shown);
}

// Every file on disk accounted for: the written entries must hide exactly the files the language does not show. Returns the totals, the
// files shown, the files per signature, the files no lamp claims, and the files whose visibility breaks the rule.
async function census(root, out, field, declared, known, globs) {
    const sets = lampSets(declared, field, known);
    const lit = new Set(Object.keys(sets).filter((name) => !out.has(name)));
    const { files } = await walkDisk(root);
    const verdict = evaluate(sets, lit, files);
    const showing = new Set(verdict.shown);
    const written = entryClaimer(globs);
    const result = { total: files.length, shown: 0, signatures: {}, unclaimed: verdict.unaccounted, wrong: [] };
    for (const place of files) {
        const signature = verdict.signatures[place];
        const label = signature.length ? signature.join("+") : "(none)";
        result.signatures[label] = (result.signatures[label] ?? 0) + 1;
        const hidden = written(place, place.split("/"));
        if (!hidden) result.shown++;
        if (hidden === showing.has(place)) result.wrong.push(place);
    }
    return result;
}

// A path of the editor's, made '/'-separated from the root; undefined when it lies outside the root.
function relativeTo(root, fsPath) {
    const relative = path.relative(root, fsPath);
    if (!relative || relative.startsWith("..") || path.isAbsolute(relative)) return undefined;
    return relative.split(path.sep).join("/");
}

// The facts in one map, a file's change and fault side by side; unstaged outranks staged for a file in both lists.
function addFact(facts, place, field, value) {
    if (!place) return;
    const fact = (facts[place] ??= {});
    if (field === "change" && fact.change === "unstaged") return;
    fact[field] = value;
}

// The change facts from the git extension's repository state: staged for the index's changes, unstaged for the working tree's, the
// untracked and the merge changes.
function gitFacts(root, state, facts = {}) {
    for (const change of state?.indexChanges ?? []) addFact(facts, relativeTo(root, change.uri.fsPath), "change", "staged");
    for (const list of [state?.workingTreeChanges, state?.untrackedChanges, state?.mergeChanges])
        for (const change of list ?? []) addFact(facts, relativeTo(root, change.uri.fsPath), "change", "unstaged");
    return facts;
}

// The fault facts from the diagnostics, [uri, diagnostics] pairs: failed for a file carrying an Error (severity 0).
function diagnosticFacts(root, entries, facts = {}) {
    for (const [uri, diagnostics] of entries ?? [])
        if ((diagnostics ?? []).some((diagnostic) => diagnostic.severity === 0)) addFact(facts, relativeTo(root, uri.fsPath), "fault", "failed");
    return facts;
}

// The module a test file tests: the folder above its first tests segment, else its own folder.
function testedModule(test) {
    const parts = test.split("/");
    const at = parts.indexOf("tests");
    return (at > 0 ? parts.slice(0, at) : parts.slice(0, -1)).join("/") || ".";
}

// The fault facts from the test-result markers, out/test-results/<test file>.failed: a marker makes its test file failed while it is
// newer than the test file and every file of the module it tests, so an edit after the run lapses it. Existence and timestamps only.
async function markerFacts(root, facts = {}) {
    const markers = (await walkDisk(path.join(root, MARKERS))).files.filter((place) => place.endsWith(".failed"));
    const newest = async (folder) => {
        let latest = 0;
        for (const place of (await walkDisk(path.join(root, folder))).files) {
            try {
                latest = Math.max(latest, (await fs.promises.stat(path.join(root, folder, place))).mtimeMs);
            } catch {}
        }
        return latest;
    };
    for (const marker of markers) {
        const test = marker.slice(0, -".failed".length);
        let written;
        let tested;
        try {
            written = (await fs.promises.stat(path.join(root, MARKERS, marker))).mtimeMs;
            tested = (await fs.promises.stat(path.join(root, test))).mtimeMs;
        } catch {
            continue;
        }
        const module = testedModule(test);
        if (written > tested && (module === "." || written > (await newest(module)))) addFact(facts, test, "fault", "failed");
    }
    return facts;
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
    const rootOf = () => vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;

    // The title row shows each lamp's icon by its two context keys, the switch and the condition.
    let conditions = {};
    const show = async () => {
        const out = new Set(context.workspaceState.get(OUT, []));
        await Promise.all(
            lamps().flatMap((lamp) => [
                vscode.commands.executeCommand("setContext", `catzc.lamps.out.${lamp}`, out.has(lamp)),
                vscode.commands.executeCommand("setContext", `catzc.lamps.state.${lamp}`, conditions[lamp] ?? "committed"),
            ]),
        );
    };
    // The conditions from the facts the editor already holds; only the facts' paths are classified, so no disk walk is needed.
    let repository;
    const judge = async () => {
        const root = rootOf();
        if (!root) return;
        const facts = gitFacts(root, repository?.state);
        diagnosticFacts(root, vscode.languages.getDiagnostics(), facts);
        await markerFacts(root, facts);
        const out = new Set(context.workspaceState.get(OUT, []));
        const sets = lampSets(filters(), context.workspaceState.get(FIELD, ""), languages());
        const next = evaluate(sets, new Set(Object.keys(sets).filter((name) => !out.has(name))), [], facts).conditions;
        if (JSON.stringify(next) === JSON.stringify(conditions)) return;
        conditions = next;
        log.appendLine(`conditions: ${Object.entries(conditions).map(([lamp, condition]) => `${lamp} ${condition}`).join(", ")}`);
        await show();
    };
    let judgeTimer;
    const rejudge = () => {
        clearTimeout(judgeTimer);
        judgeTimer = setTimeout(() => judge().catch((error) => log.appendLine(`conditions failed: ${error?.stack ?? error}`)), 300);
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
        const lit = lamps().map((lamp) => `${lamp}${out.has(lamp) ? " (off)" : ""} ${conditions[lamp] ?? "committed"}`);
        if (tally.wrong.length === 0 && tally.unclaimed.length === 0) {
            counter.text = `$(pass) ${tally.shown}/${tally.total} · everything is accounted for`;
            counter.color = "#3fb950";
            counter.tooltip = `Catzc lamps: ${tally.shown} of ${tally.total} files shown, each hidden exactly when no lit lamp claims it.\nLamps: ${lit.join(", ")}\nFiles per signature:\n${matrix.join("\n")}`;
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
        rejudge();
    };
    // Lighting the languages lamp asks which languages it shows, offering the last list; Escape keeps it unlit.
    const chooseLanguages = async () => {
        const known = Object.keys(languages());
        const answer = await vscode.window.showInputBox({
            title: "Languages to show",
            prompt: `Comma-separated; known: ${known.join(", ")}`,
            value: context.workspaceState.get(FIELD, ""),
            validateInput: (text) => {
                const unknown = typed(text).filter((name) => !known.includes(name));
                return unknown.length ? `unknown: ${unknown.join(", ")}` : undefined;
            },
        });
        if (answer === undefined) return;
        await context.workspaceState.update(FIELD, typed(answer).join(", "));
        await turn(LANGUAGE, false);
    };
    let timer;
    const refresh = () => {
        clearTimeout(timer);
        timer = setTimeout(settle, 200);
    };

    // A command pair per lamp and condition, each its own icon; committed is the bare name. The manifest declares the same names (a test
    // holds it to filters.yml and the conditions).
    for (const lamp of lamps()) {
        for (const condition of CONDITIONS) {
            const suffix = condition === "committed" ? "" : `.${condition}`;
            context.subscriptions.push(
                vscode.commands.registerCommand(`catzc.lamps.${lamp}.putOut${suffix}`, () => turn(lamp, true)),
                vscode.commands.registerCommand(`catzc.lamps.${lamp}.light${suffix}`, lamp === LANGUAGE ? chooseLanguages : () => turn(lamp, false)),
            );
        }
    }
    // The facts' sources: the git extension's repository state, the diagnostics, the markers, and a save (a marker lapses by timestamp).
    const watchGit = async () => {
        const extension = vscode.extensions.getExtension("vscode.git");
        if (!extension) return log.appendLine("conditions: no git extension, so no change facts");
        const api = (extension.isActive ? extension.exports : await extension.activate()).getAPI(1);
        const attach = () => {
            const root = key(rootOf() ?? "");
            const found = api.repositories.find((candidate) => key(candidate.rootUri.fsPath) === root) ?? api.repositories[0];
            if (!found || found === repository) return;
            repository = found;
            context.subscriptions.push(repository.state.onDidChange(rejudge));
            rejudge();
        };
        context.subscriptions.push(api.onDidOpenRepository(attach));
        attach();
    };
    watchGit().catch((error) => log.appendLine(`git facts failed: ${error?.stack ?? error}`));
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (folder) {
        const markers = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(folder, `${MARKERS}/**`));
        context.subscriptions.push(markers, markers.onDidCreate(rejudge), markers.onDidChange(rejudge), markers.onDidDelete(rejudge));
    }
    context.subscriptions.push(vscode.languages.onDidChangeDiagnostics(rejudge), vscode.workspace.onDidSaveTextDocument(rejudge));
    context.subscriptions.push(
        vscode.workspace.onDidChangeConfiguration((event) => {
            if (event.affectsConfiguration("catzc.trackLamps")) {
                rejudge();
                return refresh();
            }
            if (!event.affectsConfiguration("files.exclude")) return;
            // The lamps' own write echoes back as a change; only a change made elsewhere (a regenerated settings file) is re-applied.
            const folder = vscode.workspace.workspaceFolders?.[0];
            const now = JSON.stringify(vscode.workspace.getConfiguration("files", folder?.uri).inspect("exclude")?.workspaceValue ?? {});
            if (now !== written) refresh();
        }),
        vscode.window.onDidChangeWindowState((state) => state.focused && refresh()),
    );
    refresh();
    rejudge();
}

module.exports = {
    activate,
    deactivate() {},
    census,
    claimer,
    diagnosticFacts,
    entryClaimer,
    evaluate,
    gitFacts,
    globMatcher,
    hiddenEntries,
    hiddenGlobs,
    lampSets,
    markerFacts,
    merge,
    testedModule,
    typed,
};
