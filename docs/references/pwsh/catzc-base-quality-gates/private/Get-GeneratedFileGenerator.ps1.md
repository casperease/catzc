# pwsh/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every generator Test-GeneratedFiles can check: the registered writers, then the generators of the managed root files.

### description

A root-file generator is named by an opted-in entry of the root-config registry, so it is listed once, in registry order
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

### outputs

`[string[]]` The writer names of generated-files.yml, then the distinct generator names of rootconfig.yml.
