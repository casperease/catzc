---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "49e2849deee3"
    adrs:
      - ADR-AUTO-TEST#{1,3}
---

# automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ZshInstallLayout' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ZshInstallLayout over a fixture zsh entry: Get-ToolConfig is mocked, so the shipped tools.yml is never read
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)), and nothing on disk is touched.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
