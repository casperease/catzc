// The editor the engine runs in and the lamps it is configured with (see extension.js for the whole). vscode and the output channel are
// set once on activation (host below, since a module's binding cannot be assigned from another), so the rest is pure or reads the disk
// only and the tests drive it with node and no editor; vscode is required on activation only.

// ticked: the languages the languages button ticked into the row, in the workspace state; the engine keeps this copy current.
/** @type {{ vscode: typeof import("vscode") | undefined, log: import("vscode").OutputChannel | undefined, ticked: string[] }} */
const host = { vscode: undefined, log: undefined, ticked: [] };
// The editor, once activation has set it; every caller runs after activation, so a missing one is a wiring fault, said plainly.
const editor = () => {
    if (!host.vscode) throw new Error("the lamps' editor is not set: activateEngine sets it before anything asks for it");
    return host.vscode;
};

/** @typedef {Record<string, { tag?: string, extensions?: string[] }>} Languages each tagged language, its tag and extensions */

// The output channel is silent while all is well: a warning or an error is always written, the narration of each step only with
// catzc.trackLamps.trace on.
const trace = (/** @type {string} */ text) => editor().workspace.getConfiguration("catzc.trackLamps").get("trace") && host.log?.appendLine(text);

const config = () => editor().workspace.getConfiguration("catzc.trackLamps");
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
// A language lamp is lang-<name>, so it never collides with a filter of the same name.
const LANGUAGE = "lang-";
// The language lamps' sets, in the languages config's order (catzc.trackLamps.languages, rendered by the settings generator): one include
// per extension of each language named, none excluded.
/** @type {(languages: Languages | undefined, names: string[]) => import("./language.js").LampSets} */
const languageSets = (languages, names) =>
    Object.fromEntries(
        Object.entries(languages ?? {})
            .filter(([name]) => names.includes(name))
            .map(([name, language]) => [
                `${LANGUAGE}${name}`,
                [{ include: (language?.extensions ?? []).map((extension) => `**/*${extension}`), exclude: [] }],
            ]),
    );
const languages = () => /** @type {Languages} */ (config().get("languages") ?? {});
/** The filters the settings carry, each lamp's sets (catzc.trackLamps.filters, rendered by the settings generator). */
const settingFilters = () => /** @type {import("./language.js").LampSets} */ (config().get("filters") ?? {});
// Every declared lamp: the filters, then every tagged language, ticked or not, so an unticked language's shown key is set false.
const declaredFilters = () => ({ ...settingFilters(), ...languageSets(languages(), Object.keys(languages())) });
// The lamps in play: the shipped filters (or every filter with the flag on), then the ticked languages after them.
const filters = () => {
    const declared = settingFilters();
    const shipped = PREVIEW_LAMPS
        ? declared
        : Object.fromEntries(Object.entries(declared).filter(([name]) => SHIPPED_LAMPS.includes(name)));
    return { ...shipped, ...languageSets(languages(), host.ticked) };
};
// The flag as an assert: with it off, the lamps in play are the shipped ones in their order, or the extension says so and keeps to them.
/** @type {(all: string[]) => string[]} */
const assertShipped = (all) => {
    if (PREVIEW_LAMPS) return all;
    // The ticked language lamps stand after the filters and are no shipped lamp; the assert holds the filter lamps alone.
    const added = all.filter((lamp) => lamp.startsWith(LANGUAGE));
    return [...assertFilters(all.filter((lamp) => !lamp.startsWith(LANGUAGE))), ...added];
};
// The last mismatch the assert spoke of, so it speaks once per mismatch and not on every call.
/** @type {string | undefined} */
let mismatchSaid;
/** @type {(lamps: string[]) => string[]} */
const assertFilters = (lamps) => {
    const ok = lamps.length === SHIPPED_LAMPS.length && lamps.every((lamp, at) => lamp === SHIPPED_LAMPS[at]);
    if (!ok) {
        const said = lamps.join(",");
        if (mismatchSaid === said) return SHIPPED_LAMPS.filter((lamp) => lamps.includes(lamp));
        mismatchSaid = said;
        host.log?.appendLine(
            `error: the lamps in play [${lamps.join(", ")}] are not the shipped lamps [${SHIPPED_LAMPS.join(", ")}] in order; only the shipped ones are shown`,
        );
        return SHIPPED_LAMPS.filter((lamp) => lamps.includes(lamp));
    }
    return lamps;
};

module.exports = { host, editor, trace, config, SHIPPED_LAMPS, LANGUAGE, languageSets, languages, declaredFilters, filters, assertShipped };
