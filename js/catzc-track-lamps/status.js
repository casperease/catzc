// The status bar's line of the counter (see extension.js for the whole). Pure, so the tests drive it with node and no editor.

// The status bar's one line, within budget characters (a codicon counts as two). The census asserts itself as its sum, shown + hidden +
// out = the files on disk, '=' when it holds and '≠' when it does not, and the colour says which (accounted). The icon is the work's mood
// by the facts, red over wip over clean, and the work's counts follow while they fit, the least important dropping first.
function statusLine(tally, facts, budget = 48, view = undefined) {
    const all = Object.values(facts ?? {});
    const red = all.filter((fact) => fact?.fault === "failed").length;
    const working = all.filter((fact) => fact?.fault !== "failed");
    const unstaged = working.filter((fact) => fact?.change === "unstaged").length;
    const staged = working.filter((fact) => fact?.change === "staged").length;
    const { shown, hidden, output } = tally.sum;
    const accounted = shown + hidden + output === tally.disk && tally.wrong.length === 0;
    const mood = red ? "red" : unstaged + staged ? "wip" : "clean";
    const icon = { red: "$(error)", wip: "$(git-compare)", clean: "$(pass)" }[mood];
    // Only the hard numbers: every changed file, and of those the staged; the unstaged are the difference, never printed.
    const work = /** @type {[number, string][]} */ ([
        [red, "red"],
        [unstaged + staged, "changed"],
        [staged, "staged"],
    ])
        .filter(([n]) => n > 0)
        .map(([n, word]) => `${n} ${word}`);
    const width = (text) => text.replace(/\$\([a-z-]+\)/g, "ii").length;
    // The view in words when one fits: the repository less what is off and vetoed, or the lit lamps plus the rest, whichever is shorter;
    // the numbers otherwise. The equation's truth is the census's, so a broken one reads ≠ in the words too.
    const sum = `${shown}+${hidden}+${output}${accounted ? "=" : "≠"}${tally.disk}`;
    const worded = [];
    if (view?.name) {
        const off = (view.off ?? []).map((lamp) => ` − ${lamp}`).join("");
        const vetoed = (view.vetoed ?? []).map((lamp) => ` ∖ ${lamp}`).join("");
        worded.push(accounted ? `${view.name}${off}${vetoed}` : `${view.name}${off}${vetoed} ≠`);
        if ((view.lit ?? []).length && (view.off ?? []).length + (view.vetoed ?? []).length > 0) {
            worded.push(`${view.lit.join(" + ")} + rest ${accounted ? "=" : "≠"} ${view.name}`);
        }
    }
    const fits = worded.filter((text) => width(`${icon} ${text}`) <= budget).sort((a, b) => a.length - b.length);
    const head = `${icon} ${fits[0] ?? sum}`;
    const render = (segments) => [head, ...segments].join(" · ");
    while (work.length && width(render(work)) > budget) work.pop();
    return { text: render(work), mood, accounted };
}

module.exports = { statusLine };
