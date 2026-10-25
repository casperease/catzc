# pwsh/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
