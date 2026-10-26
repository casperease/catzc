// Drives the lamps extension's activation under node with a recording stub of the vscode API, one scenario per run, and prints what it
// recorded as JSON: node stub-editor.js <scenario> <root> <extension script>. stub-editor.test.js runs each scenario.
const fs = require("fs");
const path = require("path");

const [scenario, root, script] = process.argv.slice(2);
const sleep = (/** @type {number} */ ms) => new Promise((resolve) => setTimeout(resolve, ms));

// The stub stands in for the editor's API, so its own parameters are the editor's loose shapes: they are typed any on purpose, and what the
// scenarios read back, the record, is typed in full.
/** @typedef {(...args: any[]) => any} Callback */
/** @typedef {{ pattern: string, create: Callback[], change: Callback[], delete: Callback[] }} Watcher */
/** @param {{ filters?: unknown, state?: Record<string, unknown> }} seed */
function stub(seed) {
    /**
     * @type {{ commands: Map<string, Callback>, registered: number, disposed: number, duplicates: string[], contexts: unknown[][],
     *   updates: string[][], concurrent: number, maxConcurrent: number, watchers: Watcher[], logs: string[], diagnostics: Callback[] }}
     */
    const record = {
        commands: new Map(),
        registered: 0,
        disposed: 0,
        duplicates: [],
        contexts: [],
        updates: [],
        concurrent: 0,
        maxConcurrent: 0,
        watchers: [],
        logs: [],
        diagnostics: [],
    };
    /** @type {any} */
    let exclude = {};
    /** @type {any} */
    let owned;
    const disposable = (/** @type {Callback | undefined} */ on = undefined) => ({ dispose: () => (record.disposed++, on && on()) });
    const event = (/** @type {Callback[] | undefined} */ list = undefined) => (/** @type {Callback} */ callback) => (list && list.push(callback), disposable());
    const memento = (/** @type {Record<string, any>} */ values) => ({
        get: (/** @type {string} */ k, /** @type {any} */ d) => (k in values ? values[k] : d),
        update: async (/** @type {string} */ k, /** @type {any} */ v) => void (values[k] = v),
    });
    const vscode = {
        workspace: {
            workspaceFolders: [{ uri: { fsPath: root } }],
            getConfiguration: (/** @type {string} */ section) => ({
                get: (/** @type {string} */ k) => (section === "catzc.trackLamps" ? /** @type {Record<string, unknown>} */ ({ filters: seed.filters, trace: false })[k] : undefined),
                inspect: (/** @type {string} */ k) => ({ workspaceValue: section === "catzc.trackLamps" && k === "owned" ? owned : exclude }),
                update: async (/** @type {string} */ k, /** @type {any} */ next) => {
                    if (section === "catzc.trackLamps" && k === "owned") {
                        owned = next;
                        return;
                    }
                    record.concurrent++;
                    record.maxConcurrent = Math.max(record.maxConcurrent, record.concurrent);
                    await sleep(30);
                    exclude = next;
                    record.updates.push(Object.keys(next));
                    record.concurrent--;
                },
            }),
            createFileSystemWatcher: (/** @type {{ pattern: string }} */ pattern) => {
                /** @type {Watcher} */
                const watcher = { pattern: pattern.pattern, create: [], change: [], delete: [] };
                record.watchers.push(watcher);
                return {
                    onDidCreate: event(watcher.create),
                    onDidChange: event(watcher.change),
                    onDidDelete: event(watcher.delete),
                    ...disposable(),
                };
            },
            onDidChangeTextDocument: event(),
            onDidSaveTextDocument: event(),
            onDidChangeConfiguration: event(),
            textDocuments: [],
        },
        window: {
            createOutputChannel: (/** @type {string} */ name) => ({ appendLine: (/** @type {string} */ line) => record.logs.push(`${name}: ${line}`), show() {}, ...disposable() }),
            createStatusBarItem: () => ({ show() {}, ...disposable() }),
            tabGroups: { all: [], onDidChangeTabs: event() },
            onDidChangeActiveTextEditor: event(),
            onDidChangeWindowState: event(),
            showWarningMessage: async () => undefined,
            showInputBox: async () => undefined,
        },
        languages: {
            getDiagnostics: () => [],
            onDidChangeDiagnostics: event(record.diagnostics),
            createDiagnosticCollection: () => ({ set() {}, delete() {}, ...disposable() }),
        },
        commands: {
            registerCommand: (/** @type {string} */ name, /** @type {Callback} */ callback) => {
                if (record.commands.has(name)) record.duplicates.push(name);
                record.commands.set(name, callback);
                record.registered++;
                return disposable(() => record.commands.get(name) === callback && record.commands.delete(name));
            },
            executeCommand: async (/** @type {string} */ name, /** @type {unknown} */ key, /** @type {unknown} */ value) => void (name === "setContext" && record.contexts.push([key, value])),
        },
        extensions: { getExtension: () => undefined },
        StatusBarAlignment: { Left: 1 },
        ConfigurationTarget: { Workspace: 2 },
        /** @this {any} @param {unknown} base @param {string} pattern */
        RelativePattern: function (base, pattern) {
            this.base = base;
            this.pattern = pattern;
        },
        Uri: { file: (/** @type {string} */ p) => ({ fsPath: p, scheme: "file" }) },
        Range: function () {},
        Diagnostic: function () {},
        DiagnosticSeverity: { Error: 0 },
    };
    const context = { subscriptions: /** @type {{ dispose(): unknown }[]} */ ([]), workspaceState: memento(seed.state ?? {}), globalState: memento({}) };
    const fire = (/** @type {string} */ pattern, /** @type {"create" | "change" | "delete"} */ kind, /** @type {string} */ file) =>
        Promise.all(
            record.watchers.filter((w) => w.pattern === pattern).flatMap((w) => w[kind].map((cb) => cb({ fsPath: file, scheme: "file" }))),
        );
    const press = (/** @type {string} */ name) => record.commands.get(name)?.();
    return { vscode, record, context, fire, press };
}

// Node resolves "vscode" for the extension through this hook; the shell is the only part that requires it itself.
// _load is node's internal loader, outside its published types.
const Module = /** @type {any} */ (require("module"));
/** @type {any} */
let current;
const original = Module._load;
/** @this {any} @param {string} request @param {...any} rest */
Module._load = function (request, ...rest) {
    return request === "vscode" ? current.vscode : original.call(this, request, ...rest);
};

const filters = (/** @type {string[]} */ names) => Object.fromEntries(names.map((name) => [name, [{ include: [name, `${name}/**`], exclude: [] }]]));

const scenarios = {
    // The roof over the real repository: the files.exclude of each shipped lamp off and vetoed in turn, and of every lamp off, by the
    // rendered filters of its settings; root is the repository, and no editor is needed.
    async roof() {
        const m = require(script);
        const text = fs.readFileSync(path.join(root, ".vscode/settings.json"), "utf8").replace(/^﻿/, "");
        const settings = JSON.parse(
            text
                .split("\n")
                .filter((line) => !line.trim().startsWith("//"))
                .join("\n"),
        );
        const declared = settings["catzc.trackLamps.filters"] ?? {};
        const shipped = Object.fromEntries(Object.entries(declared).filter(([name]) => m.SHIPPED_LAMPS.includes(name)));
        const lamps = ["open", ...Object.keys(shipped)];
        const disk = await m.walkDisk(root);
        const states = [];
        for (const off of [...lamps.map((lamp) => [lamp]), lamps]) {
            for (const veto of [false, true]) {
                const out = new Set(off);
                const wanted = await m.hiddenGlobs(root, out, shipped, [], veto ? out : new Set(), disk);
                states.push({
                    state: `${veto ? "veto" : "off"} ${off.length === lamps.length ? "(every lamp)" : off[0]}`,
                    size: m.excludeSize(Object.fromEntries(wanted.map((/** @type {string} */ glob) => [glob, true]))),
                });
            }
        }
        return { roof: m.EXCLUDE_ROOF, states };
    },
    // The context keys: a lamp that is not shipped stays out of the title row, the mismatch is logged once, and a re-judge that changes
    // nothing sends no key.
    async keys() {
        current = stub({ filters: { ...filters(["code", "docs"]), widget: [{ include: ["widget/**"], exclude: [] }] } });
        require(script).activateEngine(current.context, current.vscode);
        await sleep(1500);
        const sent = current.record.contexts.length;
        for (const callback of current.record.diagnostics) callback();
        for (const callback of current.record.diagnostics) callback();
        await sleep(800);
        const keys = Object.fromEntries(current.record.contexts);
        return {
            shownCode: keys["catzc.lamps.shown.code"],
            shownWidget: keys["catzc.lamps.shown.widget"],
            summary: keys["catzc.lamps.summary"],
            mismatchLogs: current.record.logs.filter((/** @type {string} */ line) => line.includes("are not the shipped lamps")).length,
            sentAfterNoChange: current.record.contexts.length - sent,
        };
    },
    // The press queue: three presses in a row never overlap a write, and the last press has the last word.
    async queue() {
        current = stub({ filters: filters(["code", "docs"]) });
        require(script).activateEngine(current.context, current.vscode);
        await sleep(1200);
        current.press("catzc.lamps.code.veto");
        current.press("catzc.lamps.code.putOut");
        current.press("catzc.lamps.docs.veto");
        await sleep(1500);
        const afterThree = current.record.updates.at(-1) ?? [];
        current.press("catzc.lamps.code.light");
        current.press("catzc.lamps.docs.putOut");
        current.press("catzc.lamps.docs.light");
        await sleep(1500);
        return {
            maxConcurrent: current.record.maxConcurrent,
            afterThree,
            last: current.record.updates.at(-1) ?? [],
            out: current.context.workspaceState.get("catzc.trackLamps.out", []),
        };
    },
    // The file index: a file created or deleted reaches the filter from the editor's events, with no new walk of the disk.
    async index() {
        current = stub({
            filters: {
                code: [{ include: ["code", "code/**"], exclude: [] }],
                docs: [{ include: ["docs", "docs/**", "notes", "notes/**"], exclude: [] }],
            },
            state: { "catzc.trackLamps.out": ["docs"] },
        });
        require(script).activateEngine(current.context, current.vscode);
        await sleep(1500);
        const before = current.record.updates.at(-1) ?? [];
        const created = path.join(root, "notes", "n.md");
        fs.mkdirSync(path.dirname(created), { recursive: true });
        fs.writeFileSync(created, "");
        await current.fire("**", "create", created);
        await sleep(1200);
        const afterCreate = current.record.updates.at(-1) ?? [];
        const removed = path.join(root, "docs", "x.md");
        fs.unlinkSync(removed);
        await current.fire("**", "delete", removed);
        await sleep(1200);
        return { before, afterCreate, afterDelete: current.record.updates.at(-1) ?? [] };
    },
    // The hot engine: the shell runs the repository's copy, swaps it on a save with every part disposed first, and falls back to its own
    // copy when the repository's does not load.
    async swap() {
        const engine = path.join(root, "js/catzc-track-lamps/extension.js");
        current = stub({ filters: filters(["code", "docs"]) });
        require(script).activate(current.context);
        await sleep(1200);
        const first = { light: current.record.commands.has("catzc.lamps.code.light"), registered: current.record.registered };
        fs.appendFileSync(engine, "\n// a saved change\n");
        await current.fire("js/catzc-track-lamps/*.js", "change", engine);
        await sleep(1500);
        const swapped = {
            light: current.record.commands.has("catzc.lamps.code.light"),
            registered: current.record.registered,
            disposed: current.record.disposed,
        };
        fs.appendFileSync(engine, "\nthis is no javascript {\n");
        await current.fire("js/catzc-track-lamps/*.js", "change", engine);
        await sleep(1500);
        return {
            first,
            swapped,
            broken: {
                light: current.record.commands.has("catzc.lamps.code.light"),
                fellBack: current.record.logs.some((/** @type {string} */ line) => line.includes("did not load")),
            },
            duplicates: current.record.duplicates,
        };
    },
};

/** @type {Record<string, () => Promise<unknown>>} */ (scenarios)[scenario]()
    .then((/** @type {unknown} */ result) => {
        process.stdout.write(JSON.stringify(result));
        process.exit(0);
    })
    .catch((/** @type {any} */ error) => {
        process.stderr.write(String(error?.stack ?? error));
        process.exit(1);
    });
