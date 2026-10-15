---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md
    kind: comment-page
    body_sha: bf4a01a7829e
    adrs: []
---

# automation/Catzc.Tooling.Core/Invoke-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Asserts that uv is installed at the locked version before executing. uv is the standard Python handler —
it provisions Python (`uv python`) and runs Python-based CLIs in isolated environments (`uv tool`,
`uv pip`, `uv run`).
```

## comment:2

Section `.PARAMETER Prerelease` of the comment-based help.

```text
Append `--prerelease=allow`, permitting pre-release/dev dependency versions in the resolution. This is a
deliberate, surfaced choice — it emits a warning — because it pulls dev-marked packages into an otherwise
version-locked install (e.g. the Azure CLI pins beta azure-* dependencies). Never enable it silently.
```

## comment:3

Above `Write-Message "uv: allowing pre-release/dev package versions...`.

```text
Pre-release resolution is a deliberate, config-driven relaxation of the version lock — surface it so it
is never silent. A message, not a warning: the toolchain runs with WarningPreference=Stop, and this is
expected (opt-in) behaviour, not an anomaly to halt on.
```
