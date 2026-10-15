---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md
    kind: reference
    body_sha: "93f4f54f7aa6"
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam for *where* Get-BicepTemplates scans: $(Get-RepositoryRoot)/infrastructure/templates.
Production has exactly one answer. Tests redirect discovery to a fixture tree by mocking this
function (`Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates`), so unit tests never depend on
the real, shipped templates under infrastructure/templates/. Get-BicepTemplates keys its session
cache on this value, so a fixture root and the real root never collide.
```
