# pwsh/Base.QualityGates/private/Assert-TestTagGate.ps1

The gate that fails a test run when any discovered test is missing a mandatory tag or is ambiguous on one. It reads the discovery pass,
which sees every test whatever the run's level, so a tag fault cannot hide behind a tier the run excludes.

## help

### synopsis

Fails the run when any discovered test is missing — or ambiguous on — a mandatory tag axis.

### description

Enforces the two mandatory tag axes (tier L0-L4 + category logic|integrity,
[ADR-AUTO-TEST-TWOMANDATORYTAGS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags)/15) on every test of the
run's discovery pass. The discovery sees all tests regardless of -Level, so a missing or ambiguous tag fails the run even when its tier
would be excluded. Each violation is listed in red before the throw (Get-TestTagViolations owns the rules, including the optional-tag and
citation checks).

### parameter `Discovery`

The run's discovery-only Pester result (Get-TestDiscovery).
