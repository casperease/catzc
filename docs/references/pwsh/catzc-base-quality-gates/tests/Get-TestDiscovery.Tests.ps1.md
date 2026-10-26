# pwsh/Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1

The L0 logic test of `Get-TestDiscovery`. It proves that both fixture tests are discovered and none ran (the throwing bodies prove that
`SkipRun` held), and that the block chain is live: the tag consumers `Get-TestTagViolations` and `Split-TestAutomationFiles` walk it from
the discovery object.
