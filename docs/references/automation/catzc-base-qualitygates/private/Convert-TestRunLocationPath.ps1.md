---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Convert-TestRunLocationPath.ps1.md
    kind: reference
    body_sha: "2c54c1f13c1a"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Convert-TestRunLocationPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A snapshot run executes the same repository-relative files under a different root. Paths under the
working folder (SourceRoot) map to the same relative path under the location's Root, and with -ToSource
back again — test files going into a run, and the rows' File paths coming home so reports and module
protection read working-folder paths. A path outside the root (a fixture in a temp folder), an empty
value, and every path of an in-place location pass through unchanged.
```
