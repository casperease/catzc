// The /docs/drs/ links of a text: each markdown link whose target is a repository-root path under docs/drs/, with its offsets, so the
// editor opens the record on click. No editor API here, so node tests it as it is.

const PATTERN = /\[[^\]\r\n]+\]\(\/(docs\/drs\/[^)#\s]+\.md)(#[^)\s]*)?\)/g;

function drsLinks(text) {
    const found = [];
    for (const match of text.matchAll(PATTERN)) {
        // The link covers the target inside the parentheses: the path and its fragment.
        const start = match.index + match[0].indexOf("(") + 1;
        found.push({ start, end: match.index + match[0].length - 1, path: match[1], fragment: (match[2] || "").slice(1) });
    }
    return found;
}

module.exports = { drsLinks };
