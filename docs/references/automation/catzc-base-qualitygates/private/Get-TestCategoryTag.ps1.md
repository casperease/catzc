---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestCategoryTag.ps1.md
    kind: comment-page
    body_sha: "3b7a87c14118"
---

# automation/Catzc.Base.QualityGates/private/Get-TestCategoryTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the single category tag for a test — nearest contributing block wins (innermost override).
Returns $null when no block in the chain carries a category tag, or when the nearest contributing block
carries both (ambiguous); both are tagging violations surfaced by Get-TestTagViolations. A logic test
verifies a function's logic on mocks/own fixtures, independent of shipped config; an integrity test
verifies the actual repository contents (shipped configs, templates, binaries, conventions, dependency
graphs). The category tag is mandatory — there is no default (see the test-automation ADR). Shares the
block walk with Get-TestLevelTag via Get-TestBlockTag.
```
