---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-deployment-context-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f0356e833435
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sessionSubscription = Get-AzCliSessionSubscription`, written with `#`.

```text
The deploy target is the az session's subscription (in a pipeline: exactly what the service
connection logged into), reverse-resolved against azure.yml. The optional -SubscriptionIdAssertIs
guard pins it explicitly — a mismatch is a mis-wired service connection, not a retarget.
```

## comment:2

Above `$wantSlot = [string]$Slot`, written with `#`.

```text
The slot addressed is (session customer?, env, slot) — it must exist as a config, and the session
subscription must serve the env (Get-AzureEnvironment asserts that).
```

## comment:3

Above `$prepostArtifact = $null`, written with `#`.

```text
Verify the artifacts as absolute paths above (this process touches the filesystem directly), but
STORE them normalized relative-to-root where possible (ConvertTo-RepoRelativePath). A pipeline's
external $(Pipeline.Workspace) artifact area has no repo-relative form and stays absolute.
Consumers turn these back into absolute paths via Resolve-RepoPath, or hand them to az — which
runs from the repo root, so a repo-relative path resolves there.
```
