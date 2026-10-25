# pwsh/Catzc.Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-DrsDomainEdges'`, written with `#`.

```text
Get-DrsDomainEdges over a fixture DrsConfig (Get-Config mocked): the registry's own construction holds the
edge invariants (declared ends, no self-edge, acyclic), so this pins only the projection. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
