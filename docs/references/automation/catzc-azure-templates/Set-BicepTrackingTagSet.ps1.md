---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md
    kind: comment-page
    body_sha: "65acded35aea"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Called by Deploy-Bicep after a successful deploy. Resolves the scope:
- ResourceGroup target  → `/subscriptions/<id>/resourceGroups/<rg>`
- Subscription target   → `/subscriptions/<id>`

Tag *values* come from:
- Pipeline:  $env:BUILD_SOURCEVERSION / $env:BUILD_BUILDID / $env:BUILD_SOURCEBRANCH
- Devbox:    Get-GitCurrentCommit / 'CLI_NO_BUILD' / Get-GitCurrentBranch

Tag *names* are template-aware (see Get-BicepTrackTagNameSet).

Runs `az tag update --operation Merge` so unrelated tags on the scope are preserved. On a non-zero
exit it throws a self-contained error that names the target scope, the exact az command, the exit
code, and az's captured stderr/stdout — so a failure here (e.g. a tag-governing Azure Policy
colliding with the tags API, or a dropped connection) is diagnosable from the thrown error itself,
not only from the live console stream.
The target scope's subscription is the az session's (Get-AzCliSessionSubscription) — the same
session-determined target Deploy-Bicep just deployed into, so the tags land where the deploy did.
```

## comment:2

Section `.PARAMETER Slot` of the comment-based help.

```text
Optional special-slot discriminator (1-3 lowercase alphanumeric chars). Selects the same slot (and
therefore the same RG) that was deployed; omitted -> the env's base / index-0 slot.
```

## comment:3

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:4

Above `$result = Invoke-AzCli $command -PassThru -NoAssert`.

```text
-NoAssert: take the result in hand so a failure throws WITH context (scope, command, az stderr)
from here, rather than the generic exit-code assertion buried in Invoke-Executable. az's stderr is
where the real cause shows up — a RequestDisallowedByPolicy / tag-policy collision, a dropped
connection, an auth problem — so it must travel in the thrown error, not just the console stream.
```
