// The filter's write (see extension.js for the whole): one pass computes the entries for the switches as they are and writes the
// workspace's files.exclude and the list of the rows the lamps own. The engine's press queue runs the passes one at a time.

const { host, editor, trace, filters } = require("./host.js");
const { openFiles } = require("./facts.js");
const { EXCLUDE_ROOF, hiddenPlan, merge, excludeSize } = require("./tree.js");

// The setting under catzc.trackLamps that lists the files.exclude rows the lamps added (vscode-settings.yml carries them).
const OWNED_KEY = "owned";

// The files.exclude the lamps wrote last, so the settings change their own write raises is not taken for a new one.
/** @type {string | undefined} */
let written;
const lastWritten = () => written;

// One pass of the filter for the switches as they are now (state: out, vetoed): the entries computed, the settings written when
// they differ. Passes never overlap: the press queue in activate runs one at a time, the latest switches winning, so a slow write of an
// older state can never land after a newer one.
/**
 * @param {unknown} context the extension's context; a pass reads only the editor's settings
 * @param {{ out: Iterable<string>, vetoed: Iterable<string> }} state the switches as they are now
 * @param {import("./tree.js").Disk} [disk]
 */
async function apply(context, state, disk) {
    const vscode = editor();
    const folder = vscode.workspace.workspaceFolders?.[0];
    if (!folder) {
        return undefined;
    }
    const root = folder.uri.fsPath;
    const out = new Set(state.out);
    const vetoed = new Set(state.vetoed);
    const open = openFiles(root, vscode.window.tabGroups.all);
    const { globs: wanted, verdict } = await hiddenPlan(root, out, filters(), open, vetoed, disk);
    const files = vscode.workspace.getConfiguration("files", folder.uri);
    const current = /** @type {Record<string, boolean>} */ (files.inspect("exclude")?.workspaceValue ?? {});
    // The owned list lives in the settings file beside the rows, so the settings generator carries both and judges only its own part.
    const settings = vscode.workspace.getConfiguration("catzc.trackLamps", folder.uri);
    const owned = /** @type {string[]} */ (settings.inspect(OWNED_KEY)?.workspaceValue ?? []);
    const { next, ours } = merge(current, owned, wanted);
    trace(
        `apply: unlit [${[...out].join(", ")}], vetoed [${[...vetoed].join(", ")}], ${wanted.length} entries wanted, ${ours.length} owned`,
    );
    written = JSON.stringify(next);
    if (written !== JSON.stringify(current)) {
        await files.update("exclude", next, vscode.ConfigurationTarget.Workspace);
        trace(`apply: files.exclude written with ${Object.keys(next).length} keys`);
    }
    if (JSON.stringify(ours) !== JSON.stringify(owned)) {
        await settings.update(OWNED_KEY, ours.length > 0 ? ours : undefined, vscode.ConfigurationTarget.Workspace);
    }
    const size = excludeSize(next);
    if (size > EXCLUDE_ROOF) {
        host.log?.appendLine(
            `warning: files.exclude is ${size} characters in ${Object.keys(next).length} keys, over the ${EXCLUDE_ROOF} the editor's search and watcher processes take on a command line (spawn ENAMETOOLONG); unlit [${[...out].join(", ")}]`,
        );
    }
    return { root, out, vetoed, wanted, open, disk, verdict };
}

module.exports = { apply, lastWritten };
