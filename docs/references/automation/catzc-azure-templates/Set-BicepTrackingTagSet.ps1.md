---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md
    kind: comment-page
    body_sha: "3dbc11e92c34"
---

# automation/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:6

Above `$result = Invoke-AzCli $command -PassThru -NoAssert`.

```text
-NoAssert: take the result in hand so a failure throws WITH context (scope, command, az stderr)
from here, rather than the generic exit-code assertion buried in Invoke-Executable. az's stderr is
where the real cause shows up — a RequestDisallowedByPolicy / tag-policy collision, a dropped
connection, an auth problem — so it must travel in the thrown error, not just the console stream.
```
