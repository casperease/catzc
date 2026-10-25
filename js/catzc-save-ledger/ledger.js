// The parts of a save record that need no editor: the repository-relative path, the content hash and the JSON line.
// The hash is SHA-256 of the bytes with every CR removed, as the listener computes it.

const path = require("path");
const crypto = require("crypto");

function relativePath(root, file) {
    const relative = path.relative(root, file).split(path.sep).join("/");
    return relative.startsWith("..") || relative.startsWith("out/") ? null : relative;
}

function contentHash(bytes) {
    return crypto
        .createHash("sha256")
        .update(bytes.filter((b) => b !== 13))
        .digest("hex");
}

function ledgerLine(at, relative, hash) {
    return JSON.stringify({ at, event: "save", path: relative, hash }) + "\n";
}

module.exports = { relativePath, contentHash, ledgerLine };
