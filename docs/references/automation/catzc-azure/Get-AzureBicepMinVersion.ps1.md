---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureBicepMinVersion.ps1.md
    kind: comment-page
    body_sha: e80a6c5e453f
---

# automation/Catzc.Azure/Get-AzureBicepMinVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the required `bicep_min_version` global from configs/azure.yml (validated as MAJOR.MINOR.PATCH
by the AzureConfig type on load) and returns it as a [version] for comparison. Assert-AzCliBicep /
Test-AzCliBicep use it to decide whether `az bicep build` may run.
```
