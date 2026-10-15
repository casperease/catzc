---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Select-ProtectedTestFile.ps1.md
    kind: comment-page
    body_sha: "91d88664e823"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Select-ProtectedTestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Groups the run's test files by unit (Get-TestFileModule), composes each unit's protection identity
(Get-ModuleProtectionIdentity — own set + declared closure + infra + runner, widened for integrity tests
and unconstrained modules), and queries the session map. Protected units' files are removed from the
returned work-lists; unprotected units are returned as candidates for Protect-TestedModule after a green
run. In a pipeline this returns the input unchanged without computing a single identity — CI pays
nothing and skips nothing.
```
