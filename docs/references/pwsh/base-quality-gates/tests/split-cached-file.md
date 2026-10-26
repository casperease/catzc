# pwsh/Base.QualityGates/tests/Split-CachedFile.Tests.ps1

The L0 logic test of the result-cache halves that `Format-Code` and the analyzer share: `Split-CachedFile` reads, `Update-ResultCache`
writes, and `Get-ContentStamp` fingerprints a check's inputs
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)). The
fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
