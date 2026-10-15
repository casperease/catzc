---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md
    kind: test-asset
    body_sha: febab302705b
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#9
---

# automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-Zsh' -Tag 'L0', 'logic' {`.

```text
Install-Zsh on a fixture Git tree in $TestDrive: the layout, the tool config, the verified download, and the tar
extraction are mocked, so nothing downloads, no process starts, and nothing outside $TestDrive changes
([ADR-AUTO-TEST#9](/docs/adr/automation/test-automation.md#rule-adr-auto-test9)). The extraction mock writes a
fixture package with neutral names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Context 'on Linux' {`.

```text
The shared apt installer is mocked: it reads the package name from the entry's apt_package, so Install-Zsh names
only the tool, and nothing installs and no process starts.
```
