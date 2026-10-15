---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-BashTestCases.ps1.md
    kind: comment-page
    body_sha: "9ee2694afd6e"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-BashTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The language bridge's discovery for Bash: Pester discovers the bridge's tests before anything runs, so the Bash
tests are read from the source text, never from bats — discovery stays fast and offline, and works where bash is
missing (the tests then skip). Every *.bats file below the folder counts, except under a folder whose name starts
with '.' or '_'. A Bash test is a line `@test "<name>" {` (or with the name in single quotes), as bats declares it.

Each case carries its package: the file's path inside the folder, '/'-separated (repository.bats, or
nested/widget.bats), which pairs it with the BashTestResult Invoke-BashTest returns. The category follows the
BashTestResult rule: a name starting with "integrity:" is integrity, everything else logic.
```
