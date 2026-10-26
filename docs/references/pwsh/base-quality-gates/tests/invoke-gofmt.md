# pwsh/Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1

The L0 logic test of the gofmt engine `Invoke-Gofmt`, with its seams mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)). One seam is the tool probe
`Resolve-ToolExecutable`, which finds a managed `go` beside a fixture `gofmt` in `$TestDrive`; the other is `gofmt` itself, through
`Invoke-Executable`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
