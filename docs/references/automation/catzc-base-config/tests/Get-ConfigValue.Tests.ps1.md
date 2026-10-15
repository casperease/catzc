---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
    kind: test-asset
    body_sha: "711abbb55b97"
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-CONF-LOADING#1
---

# automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $script:fixture }`.

```text
Get-ConfigValue reads through Get-Config
([ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1)); mock the
reader, not a file.
```

## comment:2

Above `(Get-ConfigValue -Address 'global.tools').Contains('python') | Should -BeTrue`.

```text
tools.yml loads as the typed ToolsConfig (a read-only tool map); guards the real wiring end to end
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```
