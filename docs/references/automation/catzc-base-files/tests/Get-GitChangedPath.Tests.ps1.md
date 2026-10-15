---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md
    kind: test-asset
    body_sha: e85fe0d5ac27
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
git status is the mocked boundary: the -z porcelain it would print, NUL-separated. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
