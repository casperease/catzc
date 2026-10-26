// Filter lamps in the Explorer's title row, the editor's engine of the lamp language (DDR-FILTER): one lamp per repository filter
// (filters.yml, rendered into catzc.trackLamps.filters by the root config generator), led by the open lamp, whose sets are the files open
// in an editor. A click steps a lamp round off -> on -> veto -> off, but the open lamp is always lit: its click
// focuses the next open editor, and with no editor open its icon is invisible. The core, evaluate, is the language itself: the
// tree is the total union of the lit lamps (a file shows while any lit lamp claims it) minus the zones of the vetoed lamps (a file one
// claims is hidden even when a lit lamp claims it too), a file no lamp claims shows and is unaccounted, and each lamp's condition is the highest fact over the
// files it claims, failed > unstaged > staged > committed, whether it is lit or not. Every lamp lit is the default and shows everything.
// The adapter feeds the core from what the editor already knows: the built-in git extension's changes, the Error diagnostics, and the
// test-result markers out/test-results/<test file>.failed (Invoke-TestFile), read by existence and timestamp only.
// The title row shows each lamp's icon by two context keys, catzc.lamps.out.<lamp> (the switch) and catzc.lamps.state.<lamp> (the
// condition). Hiding writes files.exclude at workspace scope, the only filter the Explorer has; the extension owns the keys it adds and
// nothing else, so an authored exclusion survives and a regenerated settings file is re-applied. The counter in the status bar re-checks
// every file on disk against what was written, and counts the files per membership signature (the set of lamps claiming a file).
// Everything but activate is pure or reads the disk only, so the tests drive it with node and no editor; vscode is required on activation
// only. On Windows paths compare without case, as the file system does.
// This file is the entry and the shell; the parts sit beside it: glob.js (path tests), language.js (the core), tree.js (the disk and the
// written entries), status.js (the counter's line), facts.js (the conditions' sources), host.js (the editor and the lamps configured),
// apply.js (the files.exclude write) and engine.js (the editor adapter).

const fs = require("fs");
const path = require("path");
const { key, globMatcher, claimer, entryClaimer } = require("./glob.js");
const { lampSets, evaluate, summaryOf, revealFailed, nextFailed } = require("./language.js");
const { EXCLUDE_ROOF, walkDisk, hiddenEntries, hiddenGlobs, census, merge, excludeSize } = require("./tree.js");
const { statusLine } = require("./status.js");
const {
    gitFacts,
    diagnosticFacts,
    errorPlaces,
    isRemembered,
    heldFaults,
    lapsedFaults,
    remembering,
    testedModule,
    markerFacts,
    editorCount,
    openFiles,
} = require("./facts.js");
const { SHIPPED_LAMPS } = require("./host.js");
const { activateEngine } = require("./engine.js");

// The engine's file in the repository, as the shell finds it under the workspace folder.
const ENGINE = "js/catzc-track-lamps/extension.js";
// The parts beside it, which the shell reloads with the engine.
const PARTS = "js/catzc-track-lamps/*.js";

// The shell, which is all the installed package does: it runs the repository's engine, so the engine is always the working tree's, and
// on a save of that file or of a part beside it it disposes the running engine and starts the new one with the same remembered state,
// without an install or a window reload. A package change (new commands, icons, menu entries) still takes a reinstall and a reload.
// Outside this repository, or when the repository's engine fails to load, the package's own copy runs.
/** @param {import("vscode").ExtensionContext} context */
function activate(context) {
    const api = require("vscode");
    const root = api.workspace.workspaceFolders?.[0]?.uri.fsPath;
    const source = root ? path.join(root, ENGINE) : undefined;
    const same = (/** @type {string} */ a, /** @type {string} */ b) => key(path.resolve(a)) === key(path.resolve(b));
    if (!root || !source || !fs.existsSync(source) || same(source, __filename)) return activateEngine(context, api);
    const shellLog = api.window.createOutputChannel("Catzc track lamps (shell)");
    /** @type {import("./host.js").EngineContext | undefined} */
    let running;
    const stop = () => {
        for (const part of running?.subscriptions ?? []) {
            try {
                part.dispose();
            } catch {}
        }
        running = undefined;
    };
    const start = () => {
        /** @type {import("./host.js").EngineContext} */
        const engineContext = {
            subscriptions: [],
            workspaceState: context.workspaceState,
            globalState: context.globalState,
            extensionPath: context.extensionPath,
            extensionUri: context.extensionUri,
        };
        try {
            const beside = key(path.dirname(path.resolve(source)) + path.sep);
            for (const cached of Object.keys(require.cache)) if (key(cached).startsWith(beside)) delete require.cache[cached];
            require(source).activateEngine(engineContext, api);
        } catch (error) {
            for (const part of engineContext.subscriptions) {
                try {
                    part.dispose();
                } catch {}
            }
            engineContext.subscriptions.length = 0;
            shellLog.appendLine(
                `error: the repository's engine did not load, the package's copy runs instead: ${error instanceof Error ? error.stack : error}`,
            );
            activateEngine(engineContext, api);
        }
        running = engineContext;
    };
    start();
    /** @type {ReturnType<typeof setTimeout> | undefined} */
    let swap;
    const watcher = api.workspace.createFileSystemWatcher(new api.RelativePattern(root, PARTS));
    const restart = () => {
        clearTimeout(swap);
        swap = setTimeout(() => (stop(), start()), 300);
    };
    context.subscriptions.push(shellLog, watcher, watcher.onDidChange(restart), watcher.onDidCreate(restart), {
        dispose: () => (clearTimeout(swap), stop()),
    });
}

module.exports = {
    EXCLUDE_ROOF,
    SHIPPED_LAMPS,
    excludeSize,
    walkDisk,
    activate,
    activateEngine,
    deactivate() {},
    census,
    claimer,
    diagnosticFacts,
    editorCount,
    entryClaimer,
    errorPlaces,
    evaluate,
    gitFacts,
    globMatcher,
    heldFaults,
    isRemembered,
    lapsedFaults,
    remembering,
    nextFailed,
    revealFailed,
    statusLine,
    summaryOf,
    hiddenEntries,
    hiddenGlobs,
    lampSets,
    markerFacts,
    merge,
    openFiles,
    testedModule,
};
