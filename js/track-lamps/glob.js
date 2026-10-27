// The glob half of the lamp language: path tests for globs, filter sets and written exclude entries (see extension.js for the whole).
// On Windows paths compare without case, as the file system does.

const path = require("path");

/** @typedef {{ include?: string[], exclude?: string[] }} FilterSet one set of a lamp: what it includes, less what it excludes */
/** @typedef {(place: string, parts?: string[]) => boolean} Matcher a path test, given the path and, when the caller has them, its segments */

const FOLD = process.platform === "win32";
const key = (/** @type {string} */ text) => (FOLD ? text.toLowerCase() : text);
const isGlob = (/** @type {string} */ entry) => /[*?]/.test(entry);

// A path test for a glob, read the way the repository's GlobPattern reads one: '/'-separated segments, '**' a whole segment standing for
// any depth, '*' and '?' inside one segment only. The glob's literal leading segments reject a path before any wildcard is tried, and a
// caller testing many globs passes the path's segments, split once.
/**
 * @param {string} glob
 * @returns {Matcher}
 */
function globMatcher(glob) {
    const flags = FOLD ? "i" : "";
    const raw = glob.split("/");
    const segments = raw.map((/** @type {string} */ segment) =>
        segment === "**"
            ? null
            : new RegExp(
                  `^${segment
                      .replace(/[.+^${}()|[\]\\]/g, "\\$&")
                      .replace(/\*/g, "[^/]*")
                      .replace(/\?/g, "[^/]")}$`,
                  flags,
              ),
    );
    /** @type {string[]} */
    const literal = [];
    for (const segment of raw) {
        if (isGlob(segment)) break;
        literal.push(key(segment));
    }
    /** @type {(at: number, parts: string[], index: number) => boolean} */
    const from = (at, parts, index) => {
        for (; at < segments.length; at++, index++) {
            if (segments[at] === null) {
                if (at === segments.length - 1) return true;
                for (let skip = index; skip <= parts.length; skip++) if (from(at + 1, parts, skip)) return true;
                return false;
            }
            const segment = segments[at];
            if (index >= parts.length || segment === null || !segment.test(parts[index])) return false;
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
/**
 * @param {FilterSet[]} sets
 * @returns {Matcher}
 */
function claimer(sets) {
    /** @typedef {{ matches: Matcher, excludes: Matcher[] }} Entry */
    /** @type {Map<string, Entry[]>} */
    const buckets = new Map();
    /** @type {Entry[]} */
    const wild = [];
    for (const set of sets) {
        const excludes = (set.exclude ?? []).map(globMatcher);
        for (const include of set.include ?? []) {
            const entry = { matches: globMatcher(include), excludes };
            const first = include.split("/")[0];
            if (isGlob(first)) wild.push(entry);
            else {
                const at = key(first);
                const bucket = buckets.get(at) ?? [];
                bucket.push(entry);
                buckets.set(at, bucket);
            }
        }
    }
    /** @type {(entries: Entry[], place: string, parts: string[]) => boolean} */
    const tries = (entries, place, parts) =>
        entries.some(({ matches, excludes }) => matches(place, parts) && !excludes.some((excluded) => excluded(place, parts)));
    return (place, parts = place.split("/")) => tries(buckets.get(key(parts[0])) ?? [], place, parts) || tries(wild, place, parts);
}

// A claim test for written entries, read as the Explorer reads them: an entry hides what it matches and everything under it, so a path
// is claimed when it or one of its folders is a written path or matches a written glob. A folder's verdict is kept, since every file under
// it asks again.
/**
 * @param {string[]} entries
 * @returns {(place: string) => boolean}
 */
function entryClaimer(entries) {
    const places = new Set(entries.filter((entry) => !isGlob(entry)).map(key));
    const matchers = entries.filter(isGlob).map(globMatcher);
    /** @type {Map<string, boolean>} */
    const folders = new Map();
    /** @type {(at: string) => boolean} */
    const claims = (at) => {
        if (at === ".") return false;
        const known = folders.get(at);
        if (known !== undefined) return known;
        const parts = at.split("/");
        const claimed = places.has(key(at)) || matchers.some((matches) => matches(at, parts)) || claims(path.posix.dirname(at));
        folders.set(at, claimed);
        return claimed;
    };
    return (place) => {
        if (place === ".") return false;
        const parts = place.split("/");
        return places.has(key(place)) || matchers.some((matches) => matches(place, parts)) || claims(path.posix.dirname(place));
    };
}

module.exports = { FOLD, key, isGlob, globMatcher, claimer, entryClaimer };
