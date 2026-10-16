---
catzc:
  immutable:
    with_body_sha: "84ddb654f66c"
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: uninstall-zsh-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,9}
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Uninstall-Zsh' -Tag 'L0', 'logic' {`, written with `#`.

```text
Uninstall-Zsh on a fixture Git tree in $TestDrive with the layout mocked, so nothing outside $TestDrive changes
([ADR-AUTO-TEST#9](/docs/adr/automation/test-automation.md#rule-adr-auto-test9)). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Context 'on Linux' {`, written with `#`.

```text
The shared apt uninstaller is mocked: it reads the package name from the entry's apt_package and owns the
presence check and the root assert, so nothing is removed and no process starts.
```
