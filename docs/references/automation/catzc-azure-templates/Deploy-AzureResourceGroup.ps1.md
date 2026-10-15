---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Deploy-AzureResourceGroup.ps1.md
    kind: reference
    body_sha: f0348a01206a
    adrs: []
---

# automation/Catzc.Azure.Templates/Deploy-AzureResourceGroup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs `az group exists`; if missing, runs `az group create` at the given region in the given
subscription. The subscription + region are resolved by the caller (Deploy-Bicep, from the
deployment context) and passed in — this function does NOT re-resolve them from azure.yml, so the RG
is always created in the SAME subscription the deployment targets (including customer deploys).

Returns an ordered dictionary `{ name, provisioning_state }` where provisioning_state is
'Succeeded' (just created), 'Skipped' (already existed), or 'DryRun'.
```
