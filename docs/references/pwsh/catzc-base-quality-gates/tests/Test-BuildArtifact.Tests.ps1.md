# pwsh/Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1

The L0 test of `Test-BuildArtifact`, which is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Each case mocks the build, the
child-pwsh probe, the source reads and the formatter at the module boundary, and reads the collected issues. The report goes to
`$TestDrive`. The integrity blocks that build and load the real tree call the gate from their own test files.
