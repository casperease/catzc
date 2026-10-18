# pwsh/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-TestTitles' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-TestTitles over fixture test files in $TestDrive (the repository root is mocked). The fixture titles are built
from string pieces, so this file's own titles never carry the very token the gate bans. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
