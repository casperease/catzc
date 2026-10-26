# pwsh/Base.Drs/tests/types/DrsChecksConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'DrsChecksConfig'`, written with `#`.

```text
DrsChecksConfig — the ADR checks' settings (drs-checks.yml): every key optional with its default declared once on the type, and
every violation collected into one throw. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
