// The core of the lamp language (see extension.js for the whole): the lamps' sets, the evaluation of the tree, and the orchestrator's
// and the red journey's pure steps. Pure, so the tests drive it with node and no editor.

const { key, claimer } = require("./glob.js");

const OPEN = "open";
// The lamp of the run output (filters.yml), whose files the counter shows apart from the repository's own.
const OUTPUT = "out";
// The conditions by precedence, lowest first; a lamp shows the highest fact over the files it claims.
const CONDITIONS = ["committed", "staged", "unstaged", "failed"];
// A lamp whose sets include nothing (no file open, no language typed) claims no file: neutral grey.
const EMPTY = "empty";

// Every lamp's sets: the open lamp's first, one include per file open in an editor; then the declared filters' in their order.
function lampSets(declared, open = []) {
    return {
        [OPEN]: [{ include: [...open], exclude: [] }],
        ...declared,
    };
}

// The lamp language. sets: each lamp's sets; lit: the lamps on; files: the paths on disk; facts: path -> { change, fault }, where change
// is none, staged or unstaged and fault none or failed. Returns the files shown (the total union: any lit lamp claims it, or no lamp
// does), the files no lamp claims, each file's signature (the lamps claiming it, in lamp order), and each lamp's condition, the highest
// fact over the files it claims by the one precedence, or empty for a lamp whose sets include nothing. A fact's path need not be on disk
// (a deleted file is a change), and the switch never touches a condition. A vetoed lamp (unlit, and hiding its whole zone) takes out every
// file it claims, even one a lit lamp claims too: the shown files are the lit union minus the vetoed zones.
function evaluate(sets, lit, files, facts = {}, vetoed = []) {
    const vetoes = new Set(vetoed);
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
        if (signature.some((name) => vetoes.has(name))) continue;
        if (signature.length === 0 || signature.some((name) => lit.has(name))) shown.push(place);
    }
    const rank = Object.fromEntries(names.map((name) => [name, 0]));
    for (const [place, fact] of Object.entries(facts)) {
        const level = fact?.fault === "failed" ? 3 : fact?.change === "unstaged" ? 2 : fact?.change === "staged" ? 1 : 0;
        if (level === 0) continue;
        for (const name of signatures[place] ?? signatureOf(place)) rank[name] = Math.max(rank[name], level);
    }
    const empty = (name) => sets[name].every((set) => (set.include ?? []).length === 0);
    const conditions = Object.fromEntries(names.map((name) => [name, empty(name) ? EMPTY : CONDITIONS[rank[name]]]));
    return { shown, unaccounted, signatures, conditions };
}

// The orchestrator's colour over the whole repository's facts: red for any failure, blue for any work in progress, green for neither.
// It assumes the worst: the caller shows red until the first facts are in.
function summaryOf(facts) {
    const all = Object.values(facts ?? {});
    if (all.some((fact) => fact?.fault === "failed")) return "red";
    if (all.some((fact) => fact?.change === "staged" || fact?.change === "unstaged")) return "blue";
    return "green";
}

// The orchestrator's click: every red lamp lit and its veto lifted, every other lamp as it was, so no failing file stays hidden (a lamp
// is red exactly when it claims a failed file, lit or not). Returns the new switches.
function revealFailed(conditions, out, vetoed) {
    const nextOut = new Set(out);
    const nextVetoed = new Set(vetoed);
    for (const [lamp, condition] of Object.entries(conditions ?? {})) {
        if (condition !== "failed") continue;
        nextOut.delete(lamp);
        nextVetoed.delete(lamp);
    }
    return { out: [...nextOut], vetoed: [...nextVetoed] };
}

// The red journey's next stop: the failed file after the one in the editor, in path order, round to the first; the first when the
// editor holds none of them.
function nextFailed(failed, current) {
    const ordered = [...(failed ?? [])].sort();
    if (ordered.length === 0) return null;
    const at = current == null ? -1 : ordered.findIndex((place) => key(place) === key(current));
    return ordered[(at + 1) % ordered.length];
}

module.exports = { OPEN, OUTPUT, CONDITIONS, EMPTY, lampSets, evaluate, summaryOf, revealFailed, nextFailed };
