---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationRunDirectory.ps1.md
    kind: comment-page
    body_sha: "887c7223fa16"
---

# automation/Catzc.Base.QualityGates/private/New-TestAutomationRunDirectory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each Test-Automation run writes its artifacts into <OutputFolder>/yyyyMMdd-HHmmss/, suffixed -2, -3, … when
a same-second directory already exists, so rapid or concurrent runs never collide. The directory is created
before it is returned.
```
