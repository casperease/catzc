// The ANSI SGR escapes of a log text: where each escape sits, to be hidden, and the coloured spans between them, to be painted. The
// 16 standard colours and bold; any other parameter is read and ignored. No editor API here, so node tests it as it is.

const ESCAPE = /\x1b\[([0-9;]*)m/g;
const NAMES = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"];

function apply(state, parameters) {
    const codes = parameters === "" ? [0] : parameters.split(";").map(Number);
    for (const code of codes) {
        if (code === 0) Object.assign(state, { fg: null, bold: false });
        else if (code === 1) state.bold = true;
        else if (code === 22) state.bold = false;
        else if (code === 39) state.fg = null;
        else if (code >= 30 && code <= 37) state.fg = NAMES[code - 30];
        else if (code >= 90 && code <= 97) state.fg = "bright" + NAMES[code - 90][0].toUpperCase() + NAMES[code - 90].slice(1);
    }
}

function ansiSpans(text) {
    const escapes = [];
    const spans = [];
    const state = { fg: null, bold: false };
    let at = 0;
    const close = (end) => {
        if (end > at && (state.fg || state.bold)) spans.push({ start: at, end, fg: state.fg, bold: state.bold });
    };
    for (const match of text.matchAll(ESCAPE)) {
        close(match.index);
        escapes.push({ start: match.index, end: match.index + match[0].length });
        apply(state, match[1]);
        at = match.index + match[0].length;
    }
    close(text.length);
    return { escapes, spans };
}

module.exports = { ansiSpans };
