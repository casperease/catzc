# pwsh/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-Inspiration' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-Inspiration over a fixture config (Get-Config mocked to the real InspirationConfig built from neutral widget/gadget
data, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and a TestDrive workspace in
which widget and gadget exist and gizmo does not. An inspiration that is absent is reported, never thrown on
([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)).
```
