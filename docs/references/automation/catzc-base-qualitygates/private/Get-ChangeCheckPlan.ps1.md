---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ChangeCheckPlan.ps1.md
    kind: comment-page
    body_sha: aea7f7441e26
---

# automation/Catzc.Base.QualityGates/private/Get-ChangeCheckPlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The checks half of Test-Change's plan, read from configuration, not code
([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)): each changed file that exists is looked up in the
file-language registry (Get-FileLanguage -Path), and its language's `checks` list (languages.yml) names the gates.
Returns one entry per gate, in the order a gate first appears, each with the changed files it applies to. A file with
no file language, or whose language names no check, contributes nothing; a deleted file is skipped.
```
