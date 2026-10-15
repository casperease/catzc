---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestFiles.ps1.md
    kind: comment-page
    body_sha: c035a16a8a0d
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The work-list behind Test-Automation's phases: every *.Tests.ps1 under each tests/ folder (recursing, so
tests/types/ is included), in the paths' foundation-first order (Get-TestAutomationTestPaths) and, within a
folder, ordinal-sorted so the list is the same on every machine. A Go or Python test folder
(Get-LanguageTestFolders) is one run file itself: the language bridge runs it as one unit
(ConvertTo-PesterRunTarget). Throws when the paths hold no test file — a run with nothing to run is a scoping
mistake, never a green.
```
