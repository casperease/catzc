// The added lines of a zero-context diff, and the split of them into staged and unstaged.
const test = require("node:test");
const assert = require("node:assert");

const { addedLines, splitChanges } = require("../diff.js");

test("numbers the added lines from zero, a hunk without a count adding one line", () => {
    const diff = "@@ -3,0 +4,2 @@\n+a\n+b\n@@ -9 +12 @@\n-x\n+y\n";
    assert.deepStrictEqual([...addedLines(diff)], [3, 4, 11]);
});

test("a pure deletion adds no line, and an empty diff adds none", () => {
    assert.deepStrictEqual([...addedLines("@@ -5,2 +4,0 @@\n-a\n-b\n")], []);
    assert.deepStrictEqual([...addedLines("")], []);
});

test("a line in the whole diff and not in the unstaged one is staged", () => {
    const all = "@@ -1,0 +1,3 @@\n";
    const open = "@@ -2,0 +2 @@\n";
    assert.deepStrictEqual(splitChanges(all, open), { staged: [0, 2], unstaged: [1] });
});

test("with nothing unstaged every changed line is staged", () => {
    assert.deepStrictEqual(splitChanges("@@ -1 +1 @@\n", ""), { staged: [0], unstaged: [] });
});
