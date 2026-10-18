# The output directory

Every generated and transient file the automation produces lands here — reports, exports, build artifacts, test results, plans. The folder
is the single, cleanable home for output: locally it is `{repository}/out`, in a pipeline the same paths resolve to the agent's artifact
staging directory, and functions reach it only through `Get-OutputRoot` — never a hardcoded path. Nothing under it is source; everything is
safe to delete.

The contents are gitignored — only the `.gitkeep` keeping the folder tracked and this README are ever present on a fresh clone. Cleaning
everything is one command, which keeps only the `.gitkeep` and the plan files:

```powershell
Clear-Output -All
```

Every file under the root belongs to one format of `output-formats.yml` (`Catzc.Base.Reports`), and the format's area says how long it
stays: a run area (`out/test-<subject>/<stamp>/`) keeps its ten newest stamps, a build keeps the newest, a cache and a review artifact keep
everything, a session's scripts and data age out after seven days, and a log is never pruned, `out/time-safeguard.log` above all, since the
time limits are tuned from it. `Clear-Output` applies that retention and reports, never removes, a file no format covers;
`Clear-Output -DryRun` lists what would go. An agent session's own files live under `out/sessions/<session>/`, so two sessions never
overwrite each other's scripts.

Functions that produce multiple or recurring files create their own subdirectory under the root (for example `out/test-automation/<run>/`,
`out/template/<name>/`); the subfolder names are ad-hoc workspaces with no fixed contract — the root is the contract. Scratch files that are
consumed and discarded within one call do not belong here at all; they go to the system temp directory.

The governing decisions are [dedicated-output-directory](../adr/repository/dedicated-output-directory.md) (the rules: `Get-OutputRoot` for
every output path, subdirectories for recurring producers, temp for scratch, never output beside the source) and
[path-representation](../adr/automation/path-representation.md) (why a stored `out/...` path re-anchors against the context-dependent output
root, keeping artifacts portable between a devbox and a pipeline).
