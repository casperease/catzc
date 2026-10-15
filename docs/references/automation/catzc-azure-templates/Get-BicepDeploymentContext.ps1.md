---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
    kind: comment-page
    body_sha: "1ae681a7fc47"
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
