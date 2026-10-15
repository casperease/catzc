---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
    kind: test-asset
    body_sha: "6f0e577b40b0"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#9
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Uninstall-Zsh' -Tag 'L0', 'logic' {`.

```text
Uninstall-Zsh on a fixture Git tree in $TestDrive with the layout mocked, so nothing outside $TestDrive changes
([ADR-AUTO-TEST#9](/docs/adr/automation/test-automation.md#rule-adr-auto-test9)). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Context 'on Linux' {`.

```text
The shared apt uninstaller is mocked: it reads the package name from the entry's apt_package and owns the
presence check and the root assert, so nothing is removed and no process starts.
```
