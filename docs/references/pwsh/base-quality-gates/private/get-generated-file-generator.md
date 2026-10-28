# pwsh/Base.QualityGates/private/Get-GeneratedFileGenerator.ps1

Lists every generator Test-GeneratedFiles can check: the registered writers first, then the generators of the managed root files, each once
in registry order.

## help

### synopsis

Lists every generator Test-GeneratedFiles can check: the registered writers, then the generators of the managed root files.

### description

A root-file generator is named by an opted-in entry of the root-config registry, so it is listed once, in registry order
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

### outputs

`[string[]]` The writer names of the registry (Get-GeneratedWriterOrder), then the distinct generator names of rootconfig.yml.
