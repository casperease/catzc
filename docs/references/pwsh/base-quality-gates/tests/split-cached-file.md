# pwsh/Base.QualityGates/tests/Split-CachedFile.Tests.ps1

The L0 logic test of the result-cache halves that `Format-Code` and the analyzer share: `Split-CachedFile` reads, `Update-ResultCache`
writes, and `Get-ContentStamp` fingerprints a check's inputs
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)). The fixtures use neutral
names ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
