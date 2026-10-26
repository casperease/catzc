// The facts the lamps' conditions are read from (see extension.js for the whole): the built-in git extension's changes, the Error
// diagnostics (held while a language server falls silent), and the test-result markers out/test-results/<test file>.failed, read by
// existence and timestamp only, and the editor's open files. Everything here is pure or reads the disk only.

const fs = require("fs");
const path = require("path");
const { walkDisk } = require("./tree.js");

// The suffix of a remembered Error's source, and how many Errors one file remembers.
const REMEMBERED = " · remembered";
const MAX_REMEMBERED = 20;
const MARKERS = "out/test-results";

// The shapes read here, structural so the editor's objects and the tests' plain ones both fit.
/** @typedef {import("./language.js").Facts} Facts */
/** @typedef {{ fsPath: string, scheme?: string }} Uri */
/** @typedef {{ line?: number, character?: number }} Position */
/**
 * @typedef {{ severity?: number, source?: string, message?: string, range?: { start?: Position, end?: Position },
 *   code?: string | number | { value?: string | number } }} Diagnostic
 */
/** @typedef {[Uri, Diagnostic[] | undefined]} DiagnosticEntry one file's diagnostics, as the editor's getDiagnostics pairs them */
/** @typedef {{ message: string, range: number[], source: string, code?: string }} StoredError */
/** @typedef {Record<string, { seen: number, diagnostics: StoredError[] }>} Held the held faults, by place */
/** @typedef {{ uri: Uri }} Change */
/** @typedef {{ indexChanges?: Change[], workingTreeChanges?: Change[], untrackedChanges?: Change[], mergeChanges?: Change[] }} RepositoryState */
/** @typedef {{ tabs?: readonly unknown[] }} TabGroup a tab group; a tab's input is the editor's own, narrowed where it is read */

// A path of the editor's, made '/'-separated from the root; undefined when it lies outside the root.
/**
 * @param {string} root
 * @param {string} fsPath
 * @returns {string | undefined}
 */
function relativeTo(root, fsPath) {
    const relative = path.relative(root, fsPath);
    if (!relative || relative.startsWith("..") || path.isAbsolute(relative)) return undefined;
    return relative.split(path.sep).join("/");
}

// The facts in one map, a file's change and fault side by side; unstaged outranks staged for a file in both lists.
/**
 * @param {Facts} facts
 * @param {string | undefined} place
 * @param {"change" | "fault"} field
 * @param {string} value
 */
function addFact(facts, place, field, value) {
    if (!place) return;
    const fact = (facts[place] ??= {});
    if (field === "change" && fact.change === "unstaged") return;
    fact[field] = value;
}

// The change facts from the git extension's repository state: staged for the index's changes, unstaged for the working tree's, the
// untracked and the merge changes.
/**
 * @param {string} root
 * @param {RepositoryState | undefined} state
 * @param {Facts} [facts]
 * @returns {Facts}
 */
function gitFacts(root, state, facts = {}) {
    for (const change of state?.indexChanges ?? []) addFact(facts, relativeTo(root, change.uri.fsPath), "change", "staged");
    for (const list of [state?.workingTreeChanges, state?.untrackedChanges, state?.mergeChanges])
        for (const change of list ?? []) addFact(facts, relativeTo(root, change.uri.fsPath), "change", "unstaged");
    return facts;
}

// The linters a quality gate fails on for any finding: their Warnings are failures too, so a lamp never shows green what the gate
// fails (the Ruff extension reports every lint finding as a Warning). Set from catzc.trackLamps.failingSources on activation.
const FAILING_SOURCES = new Set(["Ruff", "PSScriptAnalyzer"]);
const setFailingSources = (/** @type {string[] | undefined} */ sources) => {
    FAILING_SOURCES.clear();
    for (const source of sources ?? []) FAILING_SOURCES.add(source);
};
// A diagnostic that fails its file: an Error (severity 0), or a Warning (severity 1) from a failing source.
const fails = (/** @type {Diagnostic} */ diagnostic) =>
    diagnostic.severity === 0 || (diagnostic.severity === 1 && FAILING_SOURCES.has(diagnostic.source ?? ""));

// The fault facts from the diagnostics, [uri, diagnostics] pairs: failed for a file carrying a failing diagnostic.
/**
 * @param {string} root
 * @param {DiagnosticEntry[] | undefined} entries
 * @param {Facts} [facts]
 * @returns {Facts}
 */
function diagnosticFacts(root, entries, facts = {}) {
    for (const [uri, diagnostics] of entries ?? [])
        if ((diagnostics ?? []).some(fails)) addFact(facts, relativeTo(root, uri.fsPath), "fault", "failed");
    return facts;
}

// The places carrying an Error right now, for the log line that tells a held fault from a live one.
/**
 * @param {string} root
 * @param {DiagnosticEntry[] | undefined} entries
 * @returns {string[]}
 */
function errorPlaces(root, entries) {
    return (entries ?? [])
        .filter(([, diagnostics]) => (diagnostics ?? []).some(fails))
        .map(([uri]) => relativeTo(root, uri.fsPath))
        .filter((place) => place !== undefined)
        .sort();
}

// An Error as it is stored and published again: its message, range (start line and character, end line and character), source and code.
/**
 * @param {Diagnostic} diagnostic
 * @returns {StoredError}
 */
function storedError(diagnostic) {
    const { start, end } = diagnostic.range ?? {};
    const code = typeof diagnostic.code === "object" ? diagnostic.code?.value : diagnostic.code;
    return {
        message: diagnostic.message ?? "",
        range: [start?.line ?? 0, start?.character ?? 0, end?.line ?? 0, end?.character ?? 0],
        source: diagnostic.source ?? "error",
        code: code === undefined ? undefined : String(code),
    };
}

// A diagnostic this extension published for a closed file's remembered Error; the live diagnostics are read without them.
const isRemembered = (/** @type {Diagnostic} */ diagnostic) => typeof diagnostic.source === "string" && diagnostic.source.endsWith(REMEMBERED);

// The files whose Error stays a fault while the editor's diagnostics fall silent: a language server reports a file's Error only while the
// file is open (a closed preview tab clears it) and while it is not re-analysing, and red always wins over the change colours. held maps
// a place to { seen: the time its Error was first seen, diagnostics: its Errors as last reported }; the fault stays until the file
// reports a non-error set, is edited or saved (the caller), or changes on disk after that time (lapsed); silence and a closed tab never
// release it. Returns the new map.
/**
 * @param {string} root
 * @param {Held | undefined} held
 * @param {DiagnosticEntry[] | undefined} entries
 * @param {number} [now]
 * @returns {Held}
 */
function heldFaults(root, held, entries, now = Date.now()) {
    const next = { ...(held ?? {}) };
    for (const [uri, diagnostics] of entries ?? []) {
        const place = relativeTo(root, uri.fsPath);
        if (!place) continue;
        const list = diagnostics ?? [];
        const errors = list.filter(fails);
        if (errors.length > 0)
            next[place] = { seen: next[place]?.seen ?? now, diagnostics: errors.slice(0, MAX_REMEMBERED).map(storedError) };
        else if (list.length > 0) delete next[place];
    }
    return next;
}

// The held places whose file changed on disk after its Error was seen, or is gone: the held map without them.
/**
 * @param {string} root
 * @param {Held} held
 * @returns {Promise<Held>}
 */
async function lapsedFaults(root, held) {
    const next = { ...held };
    for (const [place, fault] of Object.entries(held)) {
        try {
            if ((await fs.promises.stat(path.join(root, place))).mtimeMs > fault.seen) delete next[place];
        } catch {
            delete next[place];
        }
    }
    return next;
}

// The Errors to publish again: the held places the language servers report no Error for now, each with its stored Errors. A place with a
// live Error is left to its server, so nothing shows twice.
/**
 * @param {string} root
 * @param {Held | undefined} held
 * @param {DiagnosticEntry[] | undefined} entries
 * @returns {Record<string, StoredError[]>}
 */
function remembering(root, held, entries) {
    // Only a live Error paints the file red in the editor; a file failed by a Warning (a gate's linter) is painted gold, so its failures
    // are published as Errors too, and the tree, the tab and every folder above show red.
    const live = new Set(
        (entries ?? [])
            .filter(([, diagnostics]) => (diagnostics ?? []).some((diagnostic) => diagnostic.severity === 0))
            .map(([uri]) => relativeTo(root, uri.fsPath))
            .filter((place) => place !== undefined),
    );
    return Object.fromEntries(
        Object.entries(held ?? {})
            .filter(([place]) => !live.has(place))
            .map(([place, fault]) => [place, fault.diagnostics]),
    );
}

// The module a test file tests: the folder above its first tests segment, else its own folder.
/**
 * @param {string} test
 * @returns {string}
 */
function testedModule(test) {
    const parts = test.split("/");
    const at = parts.indexOf("tests");
    return (at > 0 ? parts.slice(0, at) : parts.slice(0, -1)).join("/") || ".";
}

// The fault facts from the test-result markers, out/test-results/<test file>.failed: a marker makes its test file failed while it is
// newer than the test file and every file of the module it tests, so an edit after the run lapses it. Existence and timestamps only.
/**
 * @param {string} root
 * @param {Facts} [facts]
 * @returns {Promise<Facts>}
 */
async function markerFacts(root, facts = {}) {
    const markers = (await walkDisk(path.join(root, MARKERS))).files.filter((place) => place.endsWith(".failed"));
    const newest = async (/** @type {string} */ folder) => {
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

// How many editors are open, every tab of every group counted, whatever it shows.
/**
 * @param {readonly TabGroup[] | undefined} tabGroups
 * @returns {number}
 */
function editorCount(tabGroups) {
    return (tabGroups ?? []).reduce((sum, group) => sum + (group?.tabs?.length ?? 0), 0);
}

// The files open in an editor, '/'-separated from the root, from the editor's tab groups: a text tab's file, a diff tab's modified side,
// a notebook's file; a tab outside the root or not on disk is none.
/**
 * @param {string} root
 * @param {readonly TabGroup[] | undefined} tabGroups
 * @returns {string[]}
 */
function openFiles(root, tabGroups) {
    /** @type {Set<string>} */
    const open = new Set();
    for (const group of tabGroups ?? [])
        for (const tab of group.tabs ?? []) {
            const input = /** @type {{ input?: { modified?: Uri, uri?: Uri } } | undefined} */ (tab)?.input;
            const uri = input?.modified ?? input?.uri;
            const place = uri?.scheme === "file" ? relativeTo(root, uri.fsPath) : undefined;
            if (place) open.add(place);
        }
    return [...open].sort();
}

module.exports = {
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
    testedModule,
    markerFacts,
    editorCount,
    openFiles,
};
