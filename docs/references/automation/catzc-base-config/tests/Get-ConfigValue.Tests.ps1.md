---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3a1be640b6ff"
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-CONF-LOADING#1
---

# automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $script:fixture }`, written with `#`.

```text
Get-ConfigValue reads through Get-Config
([ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1)); mock the
reader, not a file.
```

## comment:2

Above `(Get-ConfigValue -Address 'global.tools').Contains('python') | Should -BeTrue`, written with `#`.

```text
tools.yml loads as the typed ToolsConfig (a read-only tool map); guards the real wiring end to end
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```
