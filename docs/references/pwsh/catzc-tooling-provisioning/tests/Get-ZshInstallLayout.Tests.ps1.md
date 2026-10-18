# pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ZshInstallLayout' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ZshInstallLayout over a fixture zsh entry: Get-ToolConfig is mocked, so the shipped tools.yml is never read
([ADR-AUTO-TEST-ONECATEGORY](/docs/adr/automation/test-automation.md#rule-adr-auto-test-onecategory)), and nothing on disk is touched.
Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
