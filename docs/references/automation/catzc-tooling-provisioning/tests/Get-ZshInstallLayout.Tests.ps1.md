---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md
    kind: test-asset
    body_sha: ea9cb0549029
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ZshInstallLayout' -Tag 'L0', 'logic' {`.

```text
Get-ZshInstallLayout over a fixture zsh entry: Get-ToolConfig is mocked, so the shipped tools.yml is never read
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)), and nothing on disk is touched.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
