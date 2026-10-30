// The editor adapter of the lamp language (see extension.js for the whole): everything the lamps do in the editor, wired from the
// facts the editor already knows to the pure core and back to the context keys, the files.exclude write and the status bar counter.

const fs = require("fs");
const path = require("path");
const { key, claimer } = require("./glob.js");
const { OPEN, CONDITIONS, EMPTY, lampSets, evaluate, summaryOf, revealFailed, nextFailed } = require("./language.js");
const { host, trace, config, LANGUAGE, languages, declaredFilters, filters, assertShipped } = require("./host.js");
const { statusLine } = require("./status.js");
const { walkDisk, census } = require("./tree.js");
const {
    REMEMBERED,
    MARKERS,
    relativeTo,
    addFact,
    gitFacts,
    setFailingSources,
    fails,
    diagnosticFacts,
    errorPlaces,
    isRemembered,
    heldFaults,
    lapsedFaults,
    remembering,
    markerFacts,
    editorCount,
    openFiles,
} = require("./facts.js");
const { apply, lastWritten } = require("./apply.js");

const OUT = "catzc.trackLamps.out";
const VETO = "catzc.trackLamps.veto";
const HELD = "catzc.lamps.remembered";
const TICKED = "catzc.trackLamps.languages.ticked";

// The problem a failed test file shows: how many failed, who ran it, which levels, which run and process. A file with no result of its own
// (the place was failed some other way) gets the plain words.
/**
 * @param {import("./facts.js").TestResult | undefined} run
 * @returns {string}
 */
function failureMessage(run) {
    if (!run) return "its last test run failed";
    const levels = run.scope ? `, L${run.scope.minLevel}-L${run.scope.maxLevel}` : "";
    const folder = run.runDirectory ? `, run ${run.runDirectory.split(/[\\/]/).pop()}` : "";
    return `${run.failedCount ?? 0} failed in ${run.runner ?? "a test run"}${levels}${folder} (pid ${run.pid ?? "unknown"})`;
}

// The engine: everything the lamps do in the editor. The installed package is a shell that runs the repository's copy of this file and
// swaps it on save (activate in extension.js), so a change of logic lands without an install or a reload; api is the shell's vscode
// module, since a file outside the installed package cannot require it itself.
/**
 * @param {import("./host.js").EngineContext} context
 * @param {typeof import("vscode")} [api]
 */
function activateEngine(context, api) {
    /** @type {typeof import("vscode")} */
    const vscode = api ?? require("vscode");
    const log = vscode.window.createOutputChannel("Catzc track lamps");
    host.vscode = vscode;
    host.log = log;
    host.ticked = context.workspaceState.get(TICKED, []);
    context.subscriptions.push(log);
    /** @type {ReturnType<typeof setTimeout> | undefined} */
    let judgeTimer;
    /** @type {ReturnType<typeof setTimeout> | undefined} */
    let timer;
    // A caught error in words: its message, or its stack where the whole trace helps; a thrown non-Error is printed as it is.
    const said = (/** @type {unknown} */ error, stack = false) =>
        error instanceof Error ? ((stack ? error.stack : error.message) ?? error.message) : String(error);
    // A swapped-out engine leaves no timer behind to fire into its disposed parts.
    context.subscriptions.push({ dispose: () => (clearTimeout(judgeTimer), clearTimeout(timer)) });
    const lamps = () => assertShipped([OPEN, ...Object.keys(filters())]);
    // Every declared lamp, the preview ones included: the title row shows a lamp only while its shown key is set.
    const declaredLamps = () => [OPEN, ...Object.keys(declaredFilters())];
    const rootOf = () => vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;

    // The switches, one authoritative copy in memory: a press changes it at once, the workspace state only remembers it across reloads.
    // The open lamp is always lit: it is no switch, so a remembered switch of it is dropped.
    const state = {
        out: new Set(context.workspaceState.get(OUT, /** @type {string[]} */ ([])).filter((lamp) => lamp !== OPEN)),
        vetoed: new Set(context.workspaceState.get(VETO, /** @type {string[]} */ ([])).filter((lamp) => lamp !== OPEN)),
    };
    // The disk, indexed once and kept current from the editor's file events, so a press classifies files in memory and never walks the
    // disk; a window focus re-walks it in the background, which also covers the paths files.watcherExclude keeps the events of.
    const index = { files: new Set(), folders: new Set() };
    const rebuild = async () => {
        const root = rootOf();
        if (!root) return;
        const disk = await walkDisk(root);
        index.files = new Set(disk.files);
        index.folders = new Set(disk.folders);
    };
    let indexed = rebuild();
    const snapshot = async () => {
        await indexed;
        return { files: [...index.files], folders: [...index.folders] };
    };
    const indexAdd = async (/** @type {import("vscode").Uri} */ uri) => {
        const root = rootOf();
        const place = root && relativeTo(root, uri.fsPath);
        if (!place || place === ".git" || place.startsWith(".git/")) return;
        let stat;
        try {
            stat = await fs.promises.stat(uri.fsPath);
        } catch {
            return;
        }
        for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) index.folders.add(at);
        if (!stat.isDirectory()) return void index.files.add(place);
        index.folders.add(place);
        const inner = await walkDisk(uri.fsPath);
        for (const file of inner.files) index.files.add(`${place}/${file}`);
        for (const folder of inner.folders) index.folders.add(`${place}/${folder}`);
    };
    const indexRemove = (/** @type {import("vscode").Uri} */ uri) => {
        const root = rootOf();
        const place = root && relativeTo(root, uri.fsPath);
        if (!place) return;
        const below = `${place}/`;
        index.files.delete(place);
        index.folders.delete(place);
        for (const file of index.files) if (file.startsWith(below)) index.files.delete(file);
        for (const folder of index.folders) if (folder.startsWith(below)) index.folders.delete(folder);
    };
    // The title row shows each lamp's icon by its context keys: the switch (out: off, veto: vetoed, neither: on) and the condition. Only a
    // key whose value changed is sent, so a press costs the one or two keys it moves.
    /** @type {Record<string, string>} */
    let conditions = {};
    /** @type {Promise<import("./language.js").Facts> | null} */
    let markerCache = null;
    /** @type {Record<string, import("./facts.js").TestResult>} */
    let markerRuns = {};
    // The facts and sets of the last judgement, which the red journey reads; it never judges itself.
    /** @type {import("./language.js").Facts} */
    let lastFacts = {};
    /** @type {import("./language.js").LampSets} */
    let lastSets = {};
    /** @type {Map<string, unknown>} */
    const sent = new Map();
    const setKey = (/** @type {string} */ name, /** @type {unknown} */ value) => {
        if (sent.get(name) === value) return undefined;
        sent.set(name, value);
        return vscode.commands.executeCommand("setContext", name, value);
    };
    const show = async () => {
        const out = state.out;
        const vetoed = state.vetoed;
        const inPlay = new Set(lamps());
        await Promise.all([
            ...declaredLamps().map((lamp) => setKey(`catzc.lamps.shown.${lamp}`, inPlay.has(lamp))),
            ...[...inPlay].flatMap((lamp) => [
                setKey(`catzc.lamps.out.${lamp}`, out.has(lamp) && !vetoed.has(lamp)),
                setKey(`catzc.lamps.veto.${lamp}`, out.has(lamp) && vetoed.has(lamp)),
                setKey(`catzc.lamps.state.${lamp}`, conditions[lamp] ?? "committed"),
            ]),
        ]);
    };
    // The conditions from the facts the editor already holds; only the facts' paths are classified, so no disk walk is needed.
    /** @type {{ state: import("./facts.js").RepositoryState & { onDidChange(listener: () => void): { dispose(): unknown } }, rootUri: import("vscode").Uri } | undefined} */
    let repository;
    /** @type {import("./facts.js").Held} */
    let held = context.workspaceState.get(HELD, {});
    // A closed file's remembered Errors, published again as this extension's own diagnostics: the editor's problem decorations are the only
    // ones heavier than the git colours and the only ones that colour every folder above the file, so the Explorer row, the tab and the
    // tree show the same red as for an open file. The language servers' own Errors take over the moment they report again.
    const collection = vscode.languages.createDiagnosticCollection("catzc");
    context.subscriptions.push(collection);
    /** @type {Record<string, string>} */
    let published = {};
    /** @type {(root: string, wanted: Record<string, import("./facts.js").StoredError[]>) => void} */
    const publish = (root, wanted) => {
        for (const place of Object.keys(published)) {
            if (place in wanted) continue;
            collection.delete(vscode.Uri.file(path.join(root, place)));
            delete published[place];
        }
        for (const [place, errors] of Object.entries(wanted)) {
            const signature = JSON.stringify(errors);
            if (published[place] === signature) continue;
            const diagnostics = errors.map((error) => {
                const diagnostic = new vscode.Diagnostic(
                    new vscode.Range(error.range[0], error.range[1], error.range[2], error.range[3]),
                    error.message,
                    vscode.DiagnosticSeverity.Error,
                );
                diagnostic.source = `${error.source}${REMEMBERED}`;
                if (error.code !== undefined) diagnostic.code = error.code;
                return diagnostic;
            });
            collection.set(vscode.Uri.file(path.join(root, place)), diagnostics);
            published[place] = signature;
        }
    };
    const judge = async () => {
        const root = rootOf();
        if (!root) return;
        const facts = gitFacts(root, repository?.state);
        const sources = config().get("failingSources");
        if (Array.isArray(sources)) setFailingSources(sources);
        /** @type {import("./facts.js").DiagnosticEntry[]} */
        const entries = vscode.languages.getDiagnostics().map(([uri, diagnostics]) => [uri, diagnostics.filter((d) => !isRemembered(d))]);
        const before = JSON.stringify(context.workspaceState.get(HELD, {}));
        held = await lapsedFaults(root, heldFaults(root, held, entries));
        if (JSON.stringify(held) !== before) await context.workspaceState.update(HELD, held);
        const heldPlaces = Object.keys(held).sort();
        diagnosticFacts(root, entries, facts);
        for (const place of heldPlaces) addFact(facts, place, "fault", "failed");
        // The markers are read once and again only when a marker or a file changes, never on each diagnostics event.
        markerCache ??= markerFacts(root, {}, (markerRuns = {}));
        for (const [place, fact] of Object.entries(await markerCache)) if (fact.fault) addFact(facts, place, "fault", fact.fault);
        // Every file the lamps hold as failed shows red in the tree: the remembered Errors, and a test file whose last run failed it.
        const wanted = remembering(root, held, entries);
        const live = new Set(errorPlaces(root, entries));
        for (const [place, fact] of Object.entries(facts))
            if (fact.fault === "failed" && !(place in wanted) && !live.has(place))
                wanted[place] = [{ message: failureMessage(markerRuns[place]), range: [0, 0, 0, 0], source: "tests" }];
        publish(root, wanted);
        const sets = lampSets(filters(), openFiles(root, vscode.window.tabGroups.all));
        lastFacts = facts;
        lastSets = sets;
        const next = evaluate(sets, new Set(Object.keys(sets).filter((name) => !state.out.has(name))), [], facts).conditions;
        await setKey("catzc.lamps.summary", summaryOf(facts));
        const same = JSON.stringify(next) === JSON.stringify(conditions);
        conditions = next;
        showStatus();
        if (same) return;
        trace(
            `conditions: ${Object.entries(conditions)
                .map(([lamp, condition]) => `${lamp} ${condition}`)
                .join(", ")} | held [${heldPlaces.join(", ")}] | errors [${errorPlaces(root, entries).join(", ")}]`,
        );
        await show();
    };
    const rejudge = () => {
        clearTimeout(judgeTimer);
        judgeTimer = setTimeout(() => judge().catch((error) => log.appendLine(`conditions failed: ${error?.stack ?? error}`)), 300);
    };
    // The counter: the census's sum, green while every file is hidden exactly as its filters say, red when not; the work's mood and counts
    // follow the facts, so a judgement redraws it between censuses too.
    const counter = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    counter.command = "catzc.lamps.showLog";
    counter.text = "$(sync~spin) counting files";
    counter.show();
    /** @type {Awaited<ReturnType<typeof census>> | undefined} */
    let lastTally;
    const showStatus = () => {
        if (!lastTally) return;
        const name = path.basename(rootOf() ?? "");
        // A lamp that claims nothing (no editor open) changes no file, so the words never name it.
        const named = lamps().filter((lamp) => conditions[lamp] !== EMPTY);
        const lit = named.filter((lamp) => !state.out.has(lamp));
        const off = named.filter((lamp) => state.out.has(lamp) && !state.vetoed.has(lamp));
        const vetoed = named.filter((lamp) => state.vetoed.has(lamp));
        const status = statusLine(lastTally, lastFacts, 48, { name, lit, off, vetoed });
        counter.text = status.text;
        counter.color = status.accounted ? "#3fb950" : "#f85149";
    };
    context.subscriptions.push(
        counter,
        vscode.commands.registerCommand("catzc.lamps.showLog", () => log.show()),
    );
    const count = async (/** @type {Awaited<ReturnType<typeof apply>>} */ applied) => {
        if (!applied) return;
        const { root, out, vetoed, wanted, open, disk, verdict } = applied;
        const tally = await census(root, out, filters(), wanted, open, vetoed, disk, verdict);
        const matrix = Object.entries(tally.signatures)
            .sort((a, b) => b[1] - a[1])
            .map(([signature, files]) => `${signature}: ${files}`);
        const lit = lamps().map(
            (lamp) => `${lamp}${out.has(lamp) ? (vetoed.has(lamp) ? " (veto)" : " (off)") : ""} ${conditions[lamp] ?? "committed"}`,
        );
        lastTally = tally;
        showStatus();
        if (tally.wrong.length === 0 && tally.unclaimed.length === 0) {
            counter.tooltip = `Catzc lamps: ${tally.sum.shown} repository files shown + ${tally.sum.hidden} hidden + ${tally.sum.output} run output files under out/ = ${tally.disk} on disk, each hidden exactly when no lit lamp claims it or a vetoed lamp does.\nLamps: ${lit.join(", ")}\nFiles per signature:\n${matrix.join("\n")}`;
        } else {
            counter.tooltip = `Catzc lamps: ${tally.wrong.length} files shown or hidden against their filters, e.g. ${tally.wrong.slice(0, 3).join(", ")}; ${tally.unclaimed.length} files no filter claims, e.g. ${tally.unclaimed.slice(0, 3).join(", ")}\nClick for the log.`;
        }
        const line =
            `census: ${tally.shown}/${tally.total} shown + out ${tally.output.shown}/${tally.output.total}; ${matrix.join(", ")}; ${tally.wrong.length} against their filters` +
            `${tally.wrong.length ? ": " + tally.wrong.slice(0, 20).join(", ") : ""}; ${tally.unclaimed.length} unclaimed` +
            `${tally.unclaimed.length ? ": " + tally.unclaimed.slice(0, 20).join(", ") : ""}`;
        if (tally.wrong.length === 0 && tally.unclaimed.length === 0) trace(line);
        else log.appendLine(`warning: ${line}`);
    };
    // Every failure lands in the output channel; an unhandled rejection would vanish without a trace.
    const settle = async (retried = false) => {
        try {
            const applied = await apply(context, state, await snapshot());
            // The write is verified against what the editor now holds; a mismatch (a write lost to a concurrent edit of the settings) is
            // one more pass, never a silent disagreement between the lamps and the tree.
            const folder = vscode.workspace.workspaceFolders?.[0];
            const now = JSON.stringify(vscode.workspace.getConfiguration("files", folder?.uri).inspect("exclude")?.workspaceValue ?? {});
            if (applied && now !== lastWritten()) {
                if (!retried) return settle(true);
                log.appendLine(
                    `warning: files.exclude did not take the lamps' write (${now.length} vs ${(lastWritten() ?? "").length} characters); the tree may disagree with the lamps`,
                );
            }
            // The count runs after the filter is in place, never delaying it; its failure is logged like any other.
            count(applied).catch((error) => log.appendLine(`census failed: ${error?.stack ?? error}`));
        } catch (error) {
            log.appendLine(`apply failed: ${said(error)}`);
            // A settings file rewritten on disk meanwhile (a generator's render) is read afresh and written once more, unasked.
            if (!retried && error instanceof Error && /newer/i.test(error.message)) {
                await new Promise((resolve) => setTimeout(resolve, 1000));
                return settle(true);
            }
            const message = `Catzc track lamps could not filter: ${said(error)}`;
            // The editor refuses a settings write while settings.json is open with unsaved edits; saving it is the user's call, offered here.
            const dirty = vscode.workspace.textDocuments.find(
                (document) => document.isDirty && /[\\/]\.vscode[\\/]settings\.json$/i.test(document.uri.fsPath),
            );
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
    // The press queue: every press (and every outside event) asks for one pass, and one pass runs at a time over the switches as they are
    // when it starts; a press that lands mid-pass is served by the next pass, so the last press always has the last word and the tree is
    // in the pressed state as soon as the queue drains. The counter spins while it drains.
    /** @type {Promise<void> | null} */
    let draining = null;
    let pending = false;
    const drain = async () => {
        counter.text = "$(sync~spin) filtering";
        counter.color = undefined;
        while (pending) {
            pending = false;
            await settle();
        }
    };
    const requestApply = () => {
        pending = true;
        if (!draining) {
            draining = drain()
                .catch((error) => log.appendLine(`filtering failed: ${error?.stack ?? error}`))
                .finally(() => {
                    draining = null;
                    if (pending) requestApply();
                });
        }
        return draining;
    };
    // A click steps a lamp round off -> on -> veto -> off: the switch and its icon change at once, the pass is queued, the count follows.
    // A vetoed lamp is unlit as well, so the conditions and the open-lamp refresh read it as off.
    const turn = (/** @type {string} */ lamp, /** @type {"on" | "off" | "veto"} */ mode) => {
        if (mode === "on") state.out.delete(lamp);
        else state.out.add(lamp);
        if (mode === "veto") state.vetoed.add(lamp);
        else state.vetoed.delete(lamp);
        const remembered = Promise.all([
            context.workspaceState.update(OUT, [...state.out]),
            context.workspaceState.update(VETO, [...state.vetoed]),
        ]);
        show().catch((error) => log.appendLine(`show failed: ${error?.message ?? error}`));
        rejudge();
        requestApply();
        return remembered;
    };
    // An outside event (a settings file rendered anew, the window focused) asks for a pass through the same queue, debounced since such
    // events come in bursts; a press never waits.
    const refresh = () => {
        clearTimeout(timer);
        timer = setTimeout(requestApply, 200);
    };

    // A command per lamp state, named for what its click does and shown with the icon of the state it leaves: light (off -> on) and veto
    // (on -> veto) per condition, each its own icon, committed the bare name; putOut (veto -> off) has the one veto icon. The manifest
    // declares the same names (a test holds it to filters.yml and the conditions).
    // The red journey: a lit lamp that is red keeps its switch on a click and opens its next failed file instead, in the editor and the
    // Explorer, at the file's first failing diagnostic; each click moves on, round to the first, so every failure is visited in turn.
    const journey = async (/** @type {string} */ lamp) => {
        const root = rootOf();
        if (!root || !lastSets[lamp]) return;
        const claims = claimer(lastSets[lamp]);
        const failed = Object.entries(lastFacts)
            .filter(([place, fact]) => fact?.fault === "failed" && claims(place, place.split("/")))
            .map(([place]) => place);
        const active = vscode.window.activeTextEditor?.document.uri;
        const current = active?.scheme === "file" ? relativeTo(root, active.fsPath) : undefined;
        const place = nextFailed(failed, current);
        if (!place) return;
        const uri = vscode.Uri.file(path.join(root, place));
        const first = (vscode.languages.getDiagnostics(uri) ?? []).find(fails);
        try {
            await vscode.window.showTextDocument(uri, {
                preview: false,
                preserveFocus: false,
                ...(first ? { selection: first.range } : {}),
            });
            await vscode.commands.executeCommand("revealInExplorer", uri);
        } catch (error) {
            log.appendLine(`warning: the red journey could not open ${place}: ${said(error)}`);
        }
    };
    // The orchestrator: red until the first check says otherwise; a click while red lights every red lamp through the press queue, and
    // does nothing while blue or green.
    setKey("catzc.lamps.summary", "red");
    const orchestrate = () => {
        if (sent.get("catzc.lamps.summary") !== "red") return undefined;
        const next = revealFailed(conditions, state.out, state.vetoed);
        state.out = new Set(next.out);
        state.vetoed = new Set(next.vetoed);
        const remembered = Promise.all([
            context.workspaceState.update(OUT, [...state.out]),
            context.workspaceState.update(VETO, [...state.vetoed]),
        ]);
        show().catch((error) => log.appendLine(`show failed: ${error?.message ?? error}`));
        rejudge();
        requestApply();
        return remembered;
    };
    for (const colour of ["red", "blue", "green"]) {
        context.subscriptions.push(vscode.commands.registerCommand(`catzc.lamps.orchestrate.${colour}`, orchestrate));
    }
    // The open lamp's click focuses the next open editor, round through every group; with one editor or none it does nothing.
    const focusNext = () => {
        if (editorCount(vscode.window.tabGroups.all) < 2) return undefined;
        return vscode.commands.executeCommand("workbench.action.nextEditor");
    };
    for (const condition of [...CONDITIONS, EMPTY]) {
        const suffix = condition === "committed" ? "" : `.${condition}`;
        context.subscriptions.push(vscode.commands.registerCommand(`catzc.lamps.${OPEN}.next${suffix}`, focusNext));
    }
    // Every declared lamp has its commands, an unticked language's too, so ticking one needs no reload; the menu shows only the shown.
    for (const lamp of declaredLamps()) {
        if (lamp === OPEN) continue;
        context.subscriptions.push(vscode.commands.registerCommand(`catzc.lamps.${lamp}.putOut`, () => turn(lamp, "off")));
        for (const condition of [...CONDITIONS, EMPTY]) {
            const suffix = condition === "committed" ? "" : `.${condition}`;
            context.subscriptions.push(
                vscode.commands.registerCommand(
                    `catzc.lamps.${lamp}.veto${suffix}`,
                    condition === "failed" ? () => journey(lamp) : () => turn(lamp, "veto"),
                ),
                vscode.commands.registerCommand(`catzc.lamps.${lamp}.light${suffix}`, () => turn(lamp, "on")),
            );
        }
    }
    // The languages button: a multi-select pick of the tagged languages, the ticked ones pre-ticked; the ticked list replaces the
    // remembered one, an unticked language's switches are dropped with its lamp, and the row, the conditions and the tree follow.
    const pickLanguages = async () => {
        const offered = Object.entries(languages()).map(([name, language]) => ({
            label: language?.tag ?? name,
            description: name,
            detail: (language?.extensions ?? []).join(" "),
            picked: host.ticked.includes(name),
            name,
        }));
        const chosen = await vscode.window.showQuickPick(offered, { canPickMany: true, title: "Languages that stand in the row as lamps" });
        if (!chosen) return undefined;
        host.ticked = chosen.map((item) => item.name);
        for (const lamp of [...state.out, ...state.vetoed])
            if (lamp.startsWith(LANGUAGE) && !host.ticked.includes(lamp.slice(LANGUAGE.length))) {
                state.out.delete(lamp);
                state.vetoed.delete(lamp);
            }
        const remembered = Promise.all([
            context.workspaceState.update(TICKED, host.ticked),
            context.workspaceState.update(OUT, [...state.out]),
            context.workspaceState.update(VETO, [...state.vetoed]),
        ]);
        show().catch((error) => log.appendLine(`show failed: ${error?.message ?? error}`));
        rejudge();
        requestApply();
        return remembered;
    };
    context.subscriptions.push(vscode.commands.registerCommand("catzc.lamps.languages.pick", pickLanguages));
    // The facts' sources: the git extension's repository state, the diagnostics, the markers, and a save (a marker lapses by timestamp).
    const watchGit = async () => {
        const extension = vscode.extensions.getExtension("vscode.git");
        if (!extension) return log.appendLine("conditions: no git extension, so no change facts");
        const api = (extension.isActive ? extension.exports : await extension.activate()).getAPI(1);
        const attach = () => {
            const root = key(rootOf() ?? "");
            const found =
                api.repositories.find(
                    (/** @type {{ rootUri: import("vscode").Uri }} */ candidate) => key(candidate.rootUri.fsPath) === root,
                ) ?? api.repositories[0];
            if (!found || found === repository) return;
            repository = found;
            context.subscriptions.push(found.state.onDidChange(rejudge));
            rejudge();
        };
        context.subscriptions.push(api.onDidOpenRepository(attach));
        attach();
    };
    watchGit().catch((error) => log.appendLine(`git facts failed: ${error?.stack ?? error}`));
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (folder) {
        const markers = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(folder, `${MARKERS}/**`));
        const remark = () => ((markerCache = null), rejudge());
        context.subscriptions.push(markers, markers.onDidCreate(remark), markers.onDidChange(remark), markers.onDidDelete(remark));
        // Every file created or deleted keeps the index current; the tree follows while a lamp is unlit, and a marker may lapse.
        const anything = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(folder, "**"), false, true, false);
        const touched = () => {
            markerCache = null;
            if (state.out.size > 0) refresh();
        };
        context.subscriptions.push(
            anything,
            anything.onDidCreate((uri) => indexAdd(uri).then(touched)),
            anything.onDidDelete((uri) => (indexRemove(uri), touched())),
        );
        // A held file rewritten on disk by a tool, never through the editor, releases its held Error too: the remembered red described the
        // old content, and the language server re-reports the new content when the file is opened.
        const rewritten = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(folder, "**"), true, false, true);
        context.subscriptions.push(
            rewritten,
            rewritten.onDidChange((uri) => {
                const root = rootOf();
                const place = root && uri.scheme === "file" ? relativeTo(root, uri.fsPath) : undefined;
                if (place && place in held) release({ uri });
            }),
        );
    }
    // An edit or a save releases the file's held Error (its diagnostics re-hold it while it still has one); switching the active file
    // re-judges, so the open lamp follows the red file that was just left.
    const release = (/** @type {{ uri: import("vscode").Uri }} */ document) => {
        const root = rootOf();
        const place = root && document.uri.scheme === "file" ? relativeTo(root, document.uri.fsPath) : undefined;
        if (place && place in held) {
            held = { ...held };
            delete held[place];
        }
        rejudge();
    };
    context.subscriptions.push(
        vscode.languages.onDidChangeDiagnostics(rejudge),
        vscode.window.onDidChangeActiveTextEditor(rejudge),
        vscode.workspace.onDidChangeTextDocument((event) => event.contentChanges.length > 0 && release(event.document)),
        vscode.workspace.onDidSaveTextDocument((document) => ((markerCache = null), release(document))),
    );
    // An opened or closed editor changes the open lamp's files: its condition at once, and the tree while a lamp is unlit.
    context.subscriptions.push(
        vscode.window.tabGroups.onDidChangeTabs(() => {
            rejudge();
            if (state.out.size > 0) refresh();
        }),
    );
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
            if (now !== lastWritten()) refresh();
        }),
        vscode.window.onDidChangeWindowState((window) => {
            if (!window.focused) return;
            markerCache = null;
            indexed = rebuild().then(refresh);
        }),
    );
    refresh();
    rejudge();
}

module.exports = { activateEngine, failureMessage };
