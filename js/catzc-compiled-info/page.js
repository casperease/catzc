// The note the compiled-types editor shows: the build's name against the hash of the current sources. No editor API, so node tests load it.

const escape = (/** @type {string} */ s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

/**
 * @param {string} name
 * @returns {string | undefined}
 */
function builtHash(name) {
    return (/^Catzc\.Types\.([0-9a-f]{8})\.dll$/i.exec(name) || [])[1];
}

/**
 * @param {string} name
 * @param {string | null} current
 * @returns {string}
 */
function stateText(name, current) {
    const built = builtHash(name);
    return current === null
        ? "The sources' hash could not be read: pwsh is not on PATH or the loader did not answer."
        : built !== undefined && built.toLowerCase() === current
          ? `This is the build of the current sources (<code>${escape(current)}</code>).`
          : `The sources hash to <code>${escape(current)}</code>; this build is <code>${escape(built || name)}</code>. ` +
            "A session that loaded this build keeps it until it exits; a new pwsh loads the current one.";
}

/**
 * @param {string} name
 * @param {string | null} current
 * @param {string} info
 * @returns {string}
 */
function page(name, current, info) {
    const state = stateText(name, current);
    return `<!doctype html><html><head><meta charset="utf-8"><style>
        body { font-family: var(--vscode-font-family); color: var(--vscode-foreground); padding: 1.5rem; max-width: 60rem; line-height: 1.5; }
        h2 { font-weight: 600; } code, pre { font-family: var(--vscode-editor-font-family); }
        pre { background: var(--vscode-textBlockQuote-background); padding: .75rem; overflow: auto; }
        .state { border-left: 4px solid var(--vscode-charts-blue); padding-left: .75rem; }
    </style></head><body>
        <h2>${escape(name)}</h2>
        <p><b>This is vendored.</b> A committed build of the Catzc type sources, written by the importer. Do not edit or rebuild it by hand.</p>
        <p class="state">${state}</p>
        ${info ? `<p>Build record:</p><pre>${escape(info)}</pre>` : ""}
    </body></html>`;
}

module.exports = { escape, builtHash, stateText, page };
