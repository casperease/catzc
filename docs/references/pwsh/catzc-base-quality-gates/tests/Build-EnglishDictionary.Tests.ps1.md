# pwsh/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'the committed english.txt.gz and its stamp match the tools.yml pin and...`, written with `#`.

```text
Binds to the shipped english.txt.gz + its stamp and the pinned tools.yml version — an integrity test
([ADR-AUTO-TEST-ONECATEGORY](/docs/drs/automation/test-automation.md#rule-adr-auto-test-onecategory)). It detects a stale dictionary
WITHOUT re-running node: Test-GeneratedFiles (through Get-EnglishDictionaryDrift) checks that the gz and its
stamp ship, that the recorded cspell version matches the tools.yml pin, and that the recorded word count
matches the actual gz. Re-run Build-EnglishDictionary (and commit the gz + stamp) when it reports drift.
```
