---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Deploy-AzureResourceGroup.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "07584256fd65"
---

# automation/Catzc.Azure.Templates/tests/Deploy-AzureResourceGroup.Tests.ps1

<!-- cspell:ignore nproperties -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:subId = '50a0ed00-de00-50b0-0000-000000000000'`, written with `#`.

```text
The caller resolves the subscription + region and passes them in; this function never
re-resolves from azure.yml (so the RG always lands in the deployment's subscription).
```
