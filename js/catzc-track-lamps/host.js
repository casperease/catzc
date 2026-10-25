// The editor the engine runs in and the lamps it is configured with (see extension.js for the whole). vscode and the output channel are
// set once on activation (host below, since a module's binding cannot be assigned from another), so the rest is pure or reads the disk
// only and the tests drive it with node and no editor; vscode is required on activation only.

const host = { vscode: undefined, log: undefined };

// The output channel is silent while all is well: a warning or an error is always written, the narration of each step only with
// catzc.trackLamps.trace on.
const trace = (text) => host.vscode.workspace.getConfiguration("catzc.trackLamps").get("trace") && host.log.appendLine(text);

const config = () => host.vscode.workspace.getConfiguration("catzc.trackLamps");
// The feature flag of the preview lamps: off, only the shipped lamps take part (the title row, the filter, the conditions) and the
// preview filters of filters.yml are left out as if undeclared; on, every declared lamp does. Flip it here to try the preview lamps.
const PREVIEW_LAMPS = false;
// The shipped lamps, in their title-row order; with the flag off, the lamps that reach the menu must be exactly these, first and alone.
const SHIPPED_LAMPS = [
    "open",
    "code",
    "live",
    "configs",
    "tests",
    "tools",
    "pipelines",
    "infrastructure",
    "contracts",
    "generated",
    "docs",
    "out",
];
const declaredFilters = () => config().get("filters") ?? {};
const filters = () => {
    const declared = declaredFilters();
    if (PREVIEW_LAMPS) return declared;
    return Object.fromEntries(Object.entries(declared).filter(([name]) => SHIPPED_LAMPS.includes(name)));
};
// The flag as an assert: with it off, the lamps in play are the shipped ones in their order, or the extension says so and keeps to them.
const assertShipped = (lamps) => {
    if (PREVIEW_LAMPS) return lamps;
    const ok = lamps.length === SHIPPED_LAMPS.length && lamps.every((lamp, at) => lamp === SHIPPED_LAMPS[at]);
    if (!ok) {
        const said = lamps.join(",");
        if (assertShipped.said === said) return SHIPPED_LAMPS.filter((lamp) => lamps.includes(lamp));
        assertShipped.said = said;
        host.log?.appendLine(
            `error: the lamps in play [${lamps.join(", ")}] are not the shipped lamps [${SHIPPED_LAMPS.join(", ")}] in order; only the shipped ones are shown`,
        );
        return SHIPPED_LAMPS.filter((lamp) => lamps.includes(lamp));
    }
    return lamps;
};

module.exports = { host, trace, config, SHIPPED_LAMPS, declaredFilters, filters, assertShipped };
