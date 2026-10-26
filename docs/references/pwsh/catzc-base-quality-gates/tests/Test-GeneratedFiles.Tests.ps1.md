# pwsh/Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1

The L0 test of `Test-GeneratedFiles`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Each case mocks every generator
at the module boundary and reads the collected issues. The report goes to `$TestDrive`. The integrity blocks that run the gate over the real
tree live beside each generator's own tests.

Which writers are due is the job of `Get-GeneratedWriterDue`, which has its own tests. Here each case names the due writers, and the git
changed set still feeds the stamp check.
