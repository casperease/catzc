# pwsh/Catzc.Base.Drs/tests/Update-DrsCitation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Update-DrsCitation' -Tag 'L0', 'logic' {`, written with `#`.

```text
Update-DrsCitation rewrites one file's ADR references through a code map and a rule map. Every test writes its own
file into one shared fixture repository in $TestDrive: an ADR index of neutral widget/gizmo codes
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and the two fixture maps under
tests/assets/update-drs-citation/. In them one ADR moves whole to another code and folder, one moves folder and keeps
its code, a folder maps to a new one, one rule moves to a new ADR, and one rule collapses into a kept rule whose path
only the index names.
```
