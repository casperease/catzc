// The tree half of the lamp language (see extension.js for the whole): the disk walk, the files.exclude entries that hide what the lamps
// do not show, their merge into the settings, and the census that holds the written entries to the language. Reads the disk only.

const fs = require("fs");
const path = require("path");
const { key, claimer, entryClaimer } = require("./glob.js");
const { OUTPUT, lampSets, evaluate } = require("./language.js");

// The size of files.exclude, in characters (each entry costs its glob and a flag on the command line), past which the editor cannot spawn
// the processes it hands the list to (Windows takes 32767 characters in all).
const EXCLUDE_ROOF = 20000;

/** @typedef {{ files: string[], folders: string[] }} Disk the files and folders on disk, '/'-separated from the root */
/** @typedef {import("./language.js").LampSets} LampSets */

// The files and the folders on disk, '/'-separated from the root, in one walk; .git is no part of the tree.
/**
 * @param {string} root
 * @returns {Promise<Disk>}
 */
async function walkDisk(root) {
    /** @type {string[]} */
    const files = [];
    /** @type {string[]} */
    const folders = [];
    /** @type {(folder: string) => Promise<void>} */
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

// A file's extension as written ('.ps1'), empty for none, a dotfile, or one a glob would read as a pattern.
const extensionOf = (/** @type {string} */ place) => {
    const name = path.posix.basename(place);
    const at = name.lastIndexOf(".");
    const extension = at > 0 ? name.slice(at) : "";
    return /[*?[\]{}!,]/.test(extension) ? "" : extension;
};

// The entries that hide what the tree does not show, as few as the shown files allow, since the editor hands files.exclude to the
// processes it spawns and a long list overflows their command line. A folder that shows no file is written whole, as its topmost such
// folder (so a folder the lamps emptied leaves the tree too; one empty on disk stays, as no lamp claims it). A hidden file in a shown
// folder rides on its extension where no shown file shares it: '**/*<ext>' when none does anywhere, else '<folder>/**/*<ext>' for its
// topmost folder holding none; otherwise it is written itself, in its on-disk spelling.
/**
 * @param {string[]} files
 * @param {string[]} folders
 * @param {string[]} shown
 * @returns {string[]}
 */
function hiddenEntries(files, folders, shown) {
    /** @type {Set<string>} */
    const live = new Set();
    for (const place of shown) for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) live.add(at);
    const showing = new Set(shown);
    /** @type {(place: string) => string | undefined} */
    const topmostDead = (place) => {
        let dead;
        for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) if (!live.has(at)) dead = at;
        return dead;
    };
    // Each extension's folders that hold a shown file or a live folder of it (a glob hides a folder whose name it matches), at any depth,
    // the root as '.'.
    const shownUnder = new Set();
    for (const place of [...shown, ...live]) {
        const extension = key(extensionOf(place));
        if (!extension) continue;
        shownUnder.add(`${extension}|.`);
        for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) shownUnder.add(`${extension}|${key(at)}`);
    }
    // Each extension's folders that hold a shown file directly, for the one-level form '<folder>/*<ext>' (a module's functions hidden
    // while its tests, the same extension one folder down, show).
    const shownDirectly = new Set();
    for (const place of shown) {
        const extension = key(extensionOf(place));
        if (extension) shownDirectly.add(`${extension}|${key(path.posix.dirname(place))}`);
    }
    const rollUp = (/** @type {string} */ place) => {
        const extension = extensionOf(place);
        if (!extension) return place;
        if (!shownUnder.has(`${key(extension)}|.`)) return `**/*${extension}`;
        const parts = place.split("/");
        for (let depth = 1; depth < parts.length; depth++) {
            const folder = parts.slice(0, depth).join("/");
            if (!shownUnder.has(`${key(extension)}|${key(folder)}`)) return `${folder}/**/*${extension}`;
        }
        const folder = path.posix.dirname(place);
        if (folder !== "." && !shownDirectly.has(`${key(extension)}|${key(folder)}`) && !/[*?[\]{}!,]/.test(folder))
            return `${folder}/*${extension}`;
        return place;
    };
    // A dead folder below the root rides on its name the same way: '**/<name>' where no live folder and no shown file bears it, else
    // '<folder>/**/<name>' for its topmost folder holding none; otherwise it is written itself.
    const namedUnder = new Set();
    for (const place of [...shown, ...live]) {
        const name = key(path.posix.basename(place));
        namedUnder.add(`${name}|.`);
        for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) namedUnder.add(`${name}|${key(at)}`);
    }
    const deadEntry = (/** @type {string} */ folder) => {
        const name = path.posix.basename(folder);
        if (!folder.includes("/") || /[*?[\]{}!,]/.test(name)) return folder;
        if (!namedUnder.has(`${key(name)}|.`)) return `**/${name}`;
        const parts = folder.split("/");
        for (let depth = 1; depth < parts.length - 1; depth++) {
            const above = parts.slice(0, depth).join("/");
            if (!namedUnder.has(`${key(name)}|${key(above)}`)) return `${above}/**/${name}`;
        }
        return folder;
    };
    const entries = new Set();
    for (const place of files)
        if (!showing.has(place)) {
            const dead = topmostDead(place);
            entries.add(dead ? deadEntry(dead) : rollUp(place));
        }
    // A folder with no file below it at all stays in the tree: no lamp claims it, so nothing hides it (DDR-FILTER-EVERYFILECLAIMED), and
    // writing it would cost an entry in every state. A folder the lamps emptied holds files, so it still leaves the tree.
    const populated = new Set();
    for (const place of files) for (let at = path.posix.dirname(place); at !== "."; at = path.posix.dirname(at)) populated.add(at);
    for (const place of folders) if (!live.has(place) && populated.has(place)) entries.add(deadEntry(topmostDead(place) ?? place));
    return [...entries].sort();
}

// The entries for the unlit lamps, from one walk of the disk: out holds the unlit lamps, open the files open in an editor, vetoed the
// unlit lamps that also hide their whole zone. Every lamp lit writes nothing, as without the extension.
// disk is the extension's in-memory index of the walk ({ files, folders }); without it the disk is walked, as the tests do.
/**
 * @param {string} root
 * @param {Set<string>} out
 * @param {LampSets} declared
 * @param {string[]} [open]
 * @param {Iterable<string>} [vetoed]
 * @param {Disk} [disk]
 * @returns {Promise<string[]>}
 */
async function hiddenGlobs(root, out, declared, open = [], vetoed = [], disk = undefined) {
    const sets = lampSets(declared, open);
    const lit = new Set(Object.keys(sets).filter((name) => !out.has(name)));
    if (lit.size === Object.keys(sets).length) return [];
    const { files, folders } = disk ?? (await walkDisk(root));
    return hiddenEntries(files, folders, evaluate(sets, lit, files, {}, vetoed).shown);
}

// Every file on disk accounted for: the written entries must hide exactly the files the language does not show. Returns the totals, the
// files shown, the files per signature, the files no lamp claims, and the files whose visibility breaks the rule. The run output, the files
// the out lamp claims, is counted apart (output), since it comes and goes with every run: total and shown count the repository's own files.
/**
 * @param {string} root
 * @param {Set<string>} out
 * @param {LampSets} declared
 * @param {string[]} globs
 * @param {string[]} [open]
 * @param {Iterable<string>} [vetoed]
 * @param {Disk} [disk]
 */
async function census(root, out, declared, globs, open = [], vetoed = [], disk = undefined) {
    const sets = lampSets(declared, open);
    const lit = new Set(Object.keys(sets).filter((name) => !out.has(name)));
    const { files } = disk ?? (await walkDisk(root));
    const verdict = evaluate(sets, lit, files, {}, vetoed);
    const showing = new Set(verdict.shown);
    const written = entryClaimer(globs);
    const output = sets[OUTPUT] ? claimer(sets[OUTPUT]) : () => false;
    // The sum: the repository files the language shows, the ones the written entries hide, and the run output, each counted on its own,
    // add up to the files on disk exactly when no file is both shown and hidden, or neither.
    const result = {
        disk: files.length,
        total: 0,
        shown: 0,
        sum: { shown: 0, hidden: 0, output: 0 },
        output: { total: 0, shown: 0 },
        /** @type {Record<string, number>} */
        signatures: {},
        unclaimed: verdict.unaccounted,
        /** @type {string[]} */
        wrong: [],
    };
    for (const place of files) {
        const parts = place.split("/");
        const signature = verdict.signatures[place];
        const label = signature.length ? signature.join("+") : "(none)";
        result.signatures[label] = (result.signatures[label] ?? 0) + 1;
        const hidden = written(place);
        const isOutput = output(place, parts);
        const tally = isOutput ? result.output : result;
        tally.total++;
        if (!hidden) tally.shown++;
        if (isOutput) result.sum.output++;
        else {
            if (showing.has(place)) result.sum.shown++;
            if (hidden) result.sum.hidden++;
        }
        if (hidden === showing.has(place)) result.wrong.push(place);
    }
    return result;
}

// The next files.exclude: the current one without the keys the lamps added before, plus the wanted entries. An entry the settings
// already carry is theirs, never the lamps', so the lamps own only the keys they add.
/**
 * @param {Record<string, boolean>} current
 * @param {string[]} owned
 * @param {string[]} wanted
 * @returns {{ next: Record<string, boolean>, ours: string[] }}
 */
function merge(current, owned, wanted) {
    const authored = { ...current };
    owned.forEach((glob) => delete authored[glob]);
    const ours = wanted.filter((glob) => !(glob in authored));
    const next = { ...authored };
    ours.forEach((glob) => (next[glob] = true));
    return { next, ours };
}

// What files.exclude costs on a command line: each glob and a flag with its quotes.
const excludeSize = (/** @type {Record<string, unknown>} */ exclude) =>
    Object.keys(exclude).reduce((total, glob) => total + glob.length + 6, 0);

module.exports = { EXCLUDE_ROOF, walkDisk, hiddenEntries, hiddenGlobs, census, merge, excludeSize };
