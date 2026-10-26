# pwsh/Base.Config/tests/Config-Conventions.Tests.ps1

The backstop test of the config registry: every shipped config has a registered C# config type and loads through it, or the run fails here.

## The gate

The test runs the quality gate `Test-ShippedConfigs`, which lists every issue over the loaded code root
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The gate lives in
`Catzc.Base.QualityGates` and not in this module, because `Catzc.Base.Reports` depends on `Catzc.Base.Config`.
