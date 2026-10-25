// The lines a unified diff adds, and which of them are staged. No editor API, so node tests load it.
// Both diffs number their added lines in the working tree: HEAD..worktree gives every changed line, index..worktree the unstaged
// ones, so a line in the first and not the second is staged.

function addedLines(diff) {
    const lines = new Set();
    for (const match of diff.matchAll(/^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@/gm)) {
        const start = Number(match[1]);
        const count = match[2] === undefined ? 1 : Number(match[2]);
        for (let line = start; line < start + count; line++) lines.add(line - 1);
    }
    return lines;
}

function splitChanges(all, open) {
    const changed = addedLines(all);
    const pending = addedLines(open);
    return { staged: [...changed].filter((line) => !pending.has(line)), unstaged: [...pending] };
}

module.exports = { addedLines, splitChanges };
