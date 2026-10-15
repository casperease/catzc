---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
    kind: comment-page
    body_sha: "6efae8525c8d"
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves everything Deploy-Bicep needs into ONE immutable object with exactly three concerns —
the deployment PLAN, the build ARTIFACTS, and the target IDENTITY:

  deployment   — the plan: { template, name, mode, target, resource_group? }
  artifacts    — the built files: { did_local_build, folder, template_file, parameters_file, prepost_module? }
  environment  — the target identity: the resolved Get-AzureEnvironment (env + serving subscription)

Build-folder resolution:
- Pipeline: $ArtifactsFolder is required and is used as-is.
- Devbox + no -DoNotRebuild: Build-Bicep is invoked here, then its output is used.
- Devbox + -DoNotRebuild: the template's standard output_folder is used; the function
  throws if it does not exist.

DoNotRun handling: when the template's deployment_mode is 'DoNotRun', this function
returns $null (signal to skip) unless -OverrideDoNotRunAndRun is set.

Subscription-target templates leave `deployment.resource_group` unset and assert that
`configuration/<slot>.yml` does NOT carry a `ResourceGroup` key.
The target SUBSCRIPTION is the az session's (in a pipeline: the service connection's), resolved
against azure.yml by Get-AzCliSessionSubscription; the slot addressed is (session customer?, env,
slot). The optional -SubscriptionIdAssertIs guard pins the target explicitly. See
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```

## comment:2

Section `.PARAMETER Slot` of the comment-based help.

```text
Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Selects the slot
(config file + parameters artifact + resource group). Omitted -> the env's base / index-0 slot.
```

## comment:3

Section `.PARAMETER SubscriptionIdAssertIs` of the comment-based help.

```text
Optional guard — the subscription GUID the az session is expected to target. Throws when the
session's subscription differs (in a pipeline that means a mis-wired service connection). Never a
selector: the session always determines the target.
```

## comment:4

Above `$sessionSubscription = Get-AzCliSessionSubscription`.

```text
The deploy target is the az session's subscription (in a pipeline: exactly what the service
connection logged into), reverse-resolved against azure.yml. The optional -SubscriptionIdAssertIs
guard pins it explicitly — a mismatch is a mis-wired service connection, not a retarget.
```

## comment:5

Above `$wantSlot = [string]$Slot`.

```text
The slot addressed is (session customer?, env, slot) — it must exist as a config, and the session
subscription must serve the env (Get-AzureEnvironment asserts that).
```

## comment:6

Above `$prepostArtifact = $null`.

```text
Verify the artifacts as absolute paths above (this process touches the filesystem directly), but
STORE them normalized relative-to-root where possible (ConvertTo-RepoRelativePath). A pipeline's
external $(Pipeline.Workspace) artifact area has no repo-relative form and stays absolute.
Consumers turn these back into absolute paths via Resolve-RepoPath, or hand them to az — which
runs from the repo root, so a repo-relative path resolves there.
```

## comment:7

Above `$sessionSubscription = Get-AzCliSessionSubscription`.

```text
The deploy target is the az session's subscription (in a pipeline: exactly what the service
connection logged into), reverse-resolved against azure.yml. The optional -SubscriptionIdAssertIs
guard pins it explicitly — a mismatch is a mis-wired service connection, not a retarget.
```

## comment:8

Above `$wantSlot = [string]$Slot`.

```text
The slot addressed is (session customer?, env, slot) — it must exist as a config, and the session
subscription must serve the env (Get-AzureEnvironment asserts that).
```

## comment:9

Above `$prepostArtifact = $null`.

```text
Verify the artifacts as absolute paths above (this process touches the filesystem directly), but
STORE them normalized relative-to-root where possible (ConvertTo-RepoRelativePath). A pipeline's
external $(Pipeline.Workspace) artifact area has no repo-relative form and stays absolute.
Consumers turn these back into absolute paths via Resolve-RepoPath, or hand them to az — which
runs from the repo root, so a repo-relative path resolves there.
```
