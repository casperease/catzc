# pwsh/Catzc.Base.Docs/types/CheckMode.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Docs;`, written with `//`.

```text
How a repository check treats what it finds, set per check in its config (adr-checks.yml in Catzc.Base.Docs; links.yml and
source-conventions.yml in Catzc.Base.QualityGates), never per check in code
([ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config-exceptionisconfigentry)):
  Gate   — every finding is an issue, so the run fails until the count is 0, like any quality gate
           ([ADR-AUTO-TEST-QUALITYGATE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-qualitygate))
  Report — every finding is printed and counted, and the run never fails on it; a check starts here while its work list is
           drained, and moves to Gate once its count reaches 0
Gate is the default, declared once here as the type's zero value: a check whose config omits mode is default(CheckMode)
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
```
