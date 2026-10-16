---
catzc:
  immutable:
    with_body_sha: eb6450f21ef8
    path: docs/references/automation/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: get-tools-status-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The probed branch: a tool with candidate paths takes its location and version from the probe record
(Test-Tool -PassThru) and never starts a version job on its bare name. The probe, the package-manager oracle,
the scope and winget are mocked. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$script:twoMechanismTools = [Catzc.Base.Execution.ToolsConfig]::new([ordered]@{`, written with `#`.

```text
The MSYS2 package for Windows and an apt package for Linux, and nothing for macOS, so each platform takes
exactly one manager: msys2 on Windows, apt on Linux, the system on macOS.
```
