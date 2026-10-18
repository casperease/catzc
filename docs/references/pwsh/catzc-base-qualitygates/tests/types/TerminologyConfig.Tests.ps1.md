# pwsh/Catzc.Base.QualityGates/tests/types/TerminologyConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'TerminologyConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
Validates the compiled TerminologyConfig / TerminologyTerm types directly — the constructor is the gate
that stops an unjustified or malformed registry entry from ever producing an instance
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)). The
'categories' map is the single source of the allowed categories; 'terms' groups entries under those
category keys, so a term's category is the group it is listed under (no per-entry category field).
```
