# The output directory

Every generated and transient file the automation produces lands here — reports, exports, build artifacts, test results, plans. The folder
is the single, cleanable home for output: locally it is `{repository}/out`, in a pipeline the same paths resolve to
the agent's artifact staging directory, and functions reach it only through `Get-OutputRoot` — never a hardcoded path. Nothing under it is
source; everything is safe to delete.

The contents are gitignored — only the `.gitkeep` keeping the folder tracked and this README are ever present on a fresh clone. Cleaning
everything is one command:

```powershell
Remove-Item (Join-Path (Get-OutputRoot) '*') -Recurse -Force
```

Functions that produce multiple or recurring files create their own subdirectory under the root (for example `out/test-automation/<run>/`,
`out/template/<name>/`); the subfolder names are ad-hoc workspaces with no fixed contract — the root is the contract. Scratch files that are
consumed and discarded within one call do not belong here at all; they go to the system temp directory.

The governing decisions are [dedicated-output-directory](../adr/repository/dedicated-output-directory.md) (the rules: `Get-OutputRoot` for
every output path, subdirectories for recurring producers, temp for scratch, never output beside source) and
[path-representation](../adr/automation/path-representation.md) (why a stored `out/...` path re-anchors against the context-dependent output
root, keeping artifacts portable between a devbox and a pipeline).
