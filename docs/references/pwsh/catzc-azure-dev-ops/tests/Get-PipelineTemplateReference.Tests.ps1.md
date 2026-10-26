# pwsh/Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1

The L0 tests of the private function that extracts `template:` references from a pipeline YAML file.

## Private function

The function is private, so the tests exercise it through the module
([ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).
