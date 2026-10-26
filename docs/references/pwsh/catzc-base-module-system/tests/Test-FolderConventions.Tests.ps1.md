# pwsh/Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-FolderConventions'`, written with `#`.

```text
Test-FolderConventions over fixture module trees in $TestDrive: the repository root is mocked, so each test builds
the folders it needs and pins one convention. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
