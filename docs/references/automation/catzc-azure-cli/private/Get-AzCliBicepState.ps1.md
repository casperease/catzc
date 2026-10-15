---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md
    kind: comment-page
    body_sha: "4654c74e1c6a"
    adrs:
      - ADR-AUTO-PRELOG#5
---

# automation/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs `az bicep version`, parses the installed MAJOR.MINOR.PATCH, and compares it against
Get-AzureBicepMinVersion (azure.yml `bicep_min_version`). The single source of the comparison, shared
by Test-AzCliBicep (returns a bool) and Assert-AzCliBicep (throws), so the two cannot drift — the same
pattern as Get-AzCliConnectionState.

Returns an ordered dictionary:
  { installed, version, min_version, meets_minimum }
`installed` is false when `az bicep version` exits non-zero. `version` is the parsed [version] (or
$null when the output cannot be parsed). `meets_minimum` requires an installed, parseable version at
or above the minimum.
```

## comment:2

Above `$result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent`.

```text
-Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the
"Bicep CLI version X" line should not echo to the console on every build. See log ADR rule
[ADR-AUTO-PRELOG#5](/docs/adr/automation/log-before-invoke.md#rule-adr-auto-prelog5).
```

## comment:3

Above `$result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent`.

```text
-Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the
"Bicep CLI version X" line should not echo to the console on every build. See log ADR rule
[ADR-AUTO-PRELOG#5](/docs/adr/automation/log-before-invoke.md#rule-adr-auto-prelog5).
```
