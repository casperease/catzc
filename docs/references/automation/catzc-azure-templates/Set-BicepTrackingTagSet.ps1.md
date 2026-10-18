---
catzc:
  immutable:
    with_body_sha: "8718d4d83b07"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: set-bicep-tracking-tag-set-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the deployment-provenance tags (commit, buildId, branch) on the target scope.

### description

Called by Deploy-Bicep after a successful deploy. Resolves the scope:

- ResourceGroup target  → `/subscriptions/<id>/resourceGroups/<rg>`
- Subscription target   → `/subscriptions/<id>`

Tag _values_ come from:

- Pipeline:  $env:BUILD_SOURCEVERSION / $env:BUILD_BUILDID / $env:BUILD_SOURCEBRANCH
- Devbox:    Get-GitCurrentCommit / 'CLI_NO_BUILD' / Get-GitCurrentBranch

Tag _names_ are template-aware (see Get-BicepTrackTagNameSet).

Runs `az tag update --operation Merge` so unrelated tags on the scope are preserved. On a non-zero
exit it throws a self-contained error that names the target scope, the exact az command, the exit
code, and az's captured stderr/stdout — so a failure here (e.g. a tag-governing Azure Policy
colliding with the tags API, or a dropped connection) is diagnosable from the thrown error itself,
not only from the live console stream.
The target scope's subscription is the az session's (Get-AzCliSessionSubscription) — the same
session-determined target Deploy-Bicep just deployed into, so the tags land where the deploy did.

### parameter Environment

The environment the template was deployed to, as azure.yml names it.

### parameter Template

The Bicep template that was deployed, by name.

### parameter Slot

Optional special-slot discriminator (1-3 lowercase alphanumeric chars). Selects the same slot (and
therefore the same RG) that was deployed; omitted -> the env's base / index-0 slot.

### parameter DryRun

Preview only — log the tag command that would run and make no change.

### example 1

```powershell
Set-BicepTrackingTagSet -Environment dev -Template sample
```

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
