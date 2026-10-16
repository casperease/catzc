---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8718d4d83b07"
---

# automation/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:2

Above `$result = Invoke-AzCli $command -PassThru -NoAssert`, written with `#`.

```text
-NoAssert: take the result in hand so a failure throws WITH context (scope, command, az stderr)
from here, rather than the generic exit-code assertion buried in Invoke-Executable. az's stderr is
where the real cause shows up — a RequestDisallowedByPolicy / tag-policy collision, a dropped
connection, an auth problem — so it must travel in the thrown error, not just the console stream.
```
