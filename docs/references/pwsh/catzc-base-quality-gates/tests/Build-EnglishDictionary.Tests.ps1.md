# pwsh/Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1

The tests of `Build-EnglishDictionary`. One integrity test binds to the shipped `english.txt.gz`, its stamp and the pinned `tools.yml`
version ([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)). It finds a stale dictionary without
running node: `Test-GeneratedFiles` (through `Get-EnglishDictionaryDrift`) checks that the gz and its stamp ship, that the recorded cspell
version matches the `tools.yml` pin, and that the recorded word count matches the gz. When it reports drift, re-run
`Build-EnglishDictionary` and commit the gz and the stamp.
