// The save record: the relative path, the CR-free content hash and the JSON line.
const test = require("node:test");
const assert = require("node:assert");
const path = require("path");
const crypto = require("crypto");

const { relativePath, contentHash, ledgerLine } = require("../ledger.js");

const root = path.resolve("widget-repo");

test("gives a path under the root with forward slashes", () => {
    assert.strictEqual(relativePath(root, path.join(root, "mods", "Widget", "a.ps1")), "mods/Widget/a.ps1");
});

test("records nothing for a path outside the root or under out/", () => {
    assert.strictEqual(relativePath(root, path.resolve("gadget-repo", "a.ps1")), null);
    assert.strictEqual(relativePath(root, path.join(root, "out", "scratch.txt")), null);
});

test("hashes the bytes with every CR removed, so CRLF and LF saves agree", () => {
    const lf = Buffer.from("widget\ngadget\n");
    const crlf = Buffer.from("widget\r\ngadget\r\n");
    assert.strictEqual(contentHash(crlf), contentHash(lf));
    assert.strictEqual(contentHash(lf), crypto.createHash("sha256").update(lf).digest("hex"));
});

test("writes one JSON line per save, newline-terminated", () => {
    const line = ledgerLine("2026-01-01T00:00:00.000Z", "mods/a.ps1", "abc");
    assert.ok(line.endsWith("\n"));
    assert.deepStrictEqual(JSON.parse(line), { at: "2026-01-01T00:00:00.000Z", event: "save", path: "mods/a.ps1", hash: "abc" });
});
