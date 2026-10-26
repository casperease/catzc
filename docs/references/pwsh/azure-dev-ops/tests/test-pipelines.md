# pwsh/Azure.DevOps/tests/Test-Pipelines.Tests.ps1

The L0 tests of the quality gate that checks the pipelines tree against the naming-and-placement contract.

## Isolation

The tests isolate the gate through the classifier and reference-scan seams, so the file records and the template references are its only
inputs ([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).
