// The parts of a save record that need no editor: the repository-relative path, the content hash and the JSON line.
// The hash is SHA-256 of the bytes with every CR removed, as the listener computes it.

const path = require("path");
const crypto = require("crypto");

/**
 * @param {string} root
 * @param {string} file
 * @returns {string | null}
 */
function relativePath(root, file) {
    const relative = path.relative(root, file).split(path.sep).join("/");
    return relative.startsWith("..") || relative.startsWith("out/") ? null : relative;
}

/**
 * @param {Uint8Array} bytes
 * @returns {string}
 */
function contentHash(bytes) {
    return crypto
        .createHash("sha256")
        .update(bytes.filter((/** @type {number} */ b) => b !== 13))
        .digest("hex");
}

/**
 * @param {string} at
 * @param {string} relative
 * @param {string} hash
 * @returns {string}
 */
function ledgerLine(at, relative, hash) {
    return JSON.stringify({ at, event: "save", path: relative, hash }) + "\n";
}

module.exports = { relativePath, contentHash, ledgerLine };
