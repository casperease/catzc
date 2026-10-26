// The escapes a coloured log holds and the spans they paint.
const test = require("node:test");
const assert = require("node:assert");

const { ansiSpans, isRunLogPath } = require("../ansi.js");

test("takes a log under an out folder as a run log with either path separator, and nothing else", () => {
    assert.strictEqual(isRunLogPath("C:\\widgets\\out\\gadget\\run.log"), true);
    assert.strictEqual(isRunLogPath("/home/widget/out/gadget/run.log"), true);
    assert.strictEqual(isRunLogPath("C:\\widgets\\out\\RUN.LOG"), true);
    assert.strictEqual(isRunLogPath("C:\\widgets\\gadget\\run.log"), false);
    assert.strictEqual(isRunLogPath("/home/widget/output/run.log"), false);
    assert.strictEqual(isRunLogPath("C:\\widgets\\out\\gadget\\run.txt"), false);
});

test("hides every escape and paints the text between a colour and its reset", () => {
    const text = "plain \x1b[31mwidget failed\x1b[0m tail";
    const { escapes, spans } = ansiSpans(text);
    assert.deepStrictEqual(
        escapes.map((e) => text.slice(e.start, e.end)),
        ["\x1b[31m", "\x1b[0m"],
    );
    assert.deepStrictEqual(spans, [{ start: 11, end: 24, fg: "red", bold: false }]);
    assert.strictEqual(text.slice(spans[0].start, spans[0].end), "widget failed");
});

test("reads the bright colours, bold and a compound parameter list, and an empty reset", () => {
    const text = "\x1b[1;92mgadget\x1b[mdone";
    const { spans } = ansiSpans(text);
    assert.deepStrictEqual(spans, [{ start: 7, end: 13, fg: "brightGreen", bold: true }]);
});

test("paints nothing in a text without escapes", () => {
    assert.deepStrictEqual(ansiSpans("no colour here"), { escapes: [], spans: [] });
});
