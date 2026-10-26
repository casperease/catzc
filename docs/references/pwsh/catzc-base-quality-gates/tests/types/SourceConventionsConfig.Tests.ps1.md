# pwsh/Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SourceConventionsConfig'`, written with `#`.

```text
SourceConventionsConfig maps source-conventions.yml: an omitted check takes every default of its type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and an unknown key fails at
construction.
```
