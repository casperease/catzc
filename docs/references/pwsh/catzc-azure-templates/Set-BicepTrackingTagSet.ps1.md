# pwsh/Azure.Templates/Set-BicepTrackingTagSet.ps1

The command that writes the deployment-provenance tags (commit, build id, branch) on the target scope. It previews with `-DryRun` rather
than `ShouldProcess` ([ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md)).

## help

### synopsis

Writes the deployment-provenance tags (commit, buildId, branch) on the target scope.

### description

Called by Deploy-Bicep after a successful deploy. Resolves the scope:

- ResourceGroup target → `/subscriptions/<id>/resourceGroups/<rg>`
- Subscription target → `/subscriptions/<id>`

Tag _values_ come from:

- Pipeline: $env:BUILD_SOURCEVERSION / $env:BUILD_BUILDID / $env:BUILD_SOURCEBRANCH
- Devbox: Get-GitCurrentCommit / 'CLI_NO_BUILD' / Get-GitCurrentBranch

Tag _names_ are template-aware (see Get-BicepTrackTagNameSet).

Runs `az tag update --operation Merge` so unrelated tags on the scope are preserved. On a non-zero exit it throws a self-contained error
that names the target scope, the exact az command, the exit code, and az's captured stderr/stdout — so a failure here (e.g. a tag-governing
Azure Policy colliding with the tags API, or a dropped connection) is diagnosable from the thrown error itself, not only from the live
console stream. The target scope's subscription is the az session's (Get-AzCliSessionSubscription) — the same session-determined target
Deploy-Bicep just deployed into, so the tags land where the deploy did.

### parameter `Environment`

The environment the template was deployed to, as azure.yml names it.

### parameter `Template`

The Bicep template that was deployed, by name.

### parameter `Slot`

Optional special-slot discriminator (1-3 lowercase alphanumeric chars). Selects the same slot (and therefore the same RG) that was deployed;
omitted -> the env's base / index-0 slot.

### parameter `DryRun`

Preview only — log the tag command that would run and make no change.

### example 1

```powershell
Set-BicepTrackingTagSet -Environment dev -Template sample
```

## The target and failures

The scope is the az session's subscription, the same session-determined target the deploy used.

The tag call passes `-NoAssert` and takes the result in hand, so a failure throws from the command with its context: the scope, the command
and az's stderr. The real cause shows up in az's stderr, a `RequestDisallowedByPolicy` tag-policy collision, a dropped connection or an auth
problem, so it must travel in the thrown error and not only the console stream.
