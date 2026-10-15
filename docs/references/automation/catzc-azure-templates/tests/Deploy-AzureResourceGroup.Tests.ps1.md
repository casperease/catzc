---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Deploy-AzureResourceGroup.Tests.ps1.md
    kind: test-asset
    body_sha: ea0254ea5f1b
---

# automation/Catzc.Azure.Templates/tests/Deploy-AzureResourceGroup.Tests.ps1

<!-- cspell:ignore nproperties -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:subId = '50a0ed00-de00-50b0-0000-000000000000'`.

```text
The caller resolves the subscription + region and passes them in; this function never
re-resolves from azure.yml (so the RG always lands in the deployment's subscription).
```
