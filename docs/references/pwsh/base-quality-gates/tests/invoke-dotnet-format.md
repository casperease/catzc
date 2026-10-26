# pwsh/Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1

The L0 logic test of the dotnet-format engine `Invoke-DotnetFormat`, with the tool boundary mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)). The mock answers like
`dotnet format whitespace --verify-no-changes --report`, writing the JSON report the engine reads. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## The offline guard

The fixture repository has no generated `nuget.config`, so `Assert-DotnetOffline` is mocked to do nothing. The guard's own cases live in
`Assert-DotnetOffline.Tests.ps1`.
