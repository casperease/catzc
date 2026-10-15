---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestFileModule.ps1.md
    kind: comment-page
    body_sha: "323218c61363"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Maps an absolute run-file path to its owning unit for per-module protection
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a module
folder name ('Catzc.Base.Globs') or a dot-prefixed infra test unit ('.internal', '.scriptanalyzer'). A Go or
Python test folder (<root>/tests/<module in kebab case>, Get-LanguageTestFolders) belongs to the catzc module it
is named for, so its tests protect and invalidate that module.
```
