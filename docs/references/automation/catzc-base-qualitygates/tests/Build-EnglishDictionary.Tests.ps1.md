---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md
    kind: test-asset
    body_sha: "7612abd48306"
    adrs:
      - ADR-AUTO-TEST#1
---

# automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `It 'the committed english.txt.gz and its stamp match the tools.yml pin and...`.

```text
Binds to the shipped english.txt.gz + its stamp and the pinned tools.yml version — an integrity test
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). It detects a stale dictionary
WITHOUT re-running node: Test-GeneratedFiles (through Get-EnglishDictionaryDrift) checks that the gz and its
stamp ship, that the recorded cspell version matches the tools.yml pin, and that the recorded word count
matches the actual gz. Re-run Build-EnglishDictionary (and commit the gz + stamp) when it reports drift.
```
