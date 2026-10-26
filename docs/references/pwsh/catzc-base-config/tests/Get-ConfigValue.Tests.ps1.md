# pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $script:fixture }`, written with `#`.

```text
Get-ConfigValue reads through Get-Config
([ADR-CONF-LOADING-ONEREADER](/docs/drs/configuration/module-config-loading.md#rule-adr-conf-loading-onereader)); mock the
reader, not a file.
```

## comment:2

Above `(Get-ConfigValue -Address 'global.tools').Contains('python') | Should -BeTrue`, written with `#`.

```text
tools.yml loads as the typed ToolsConfig (a read-only tool map); guards the real wiring end to end
([ADR-AUTO-TEST-LOGICANDINTEGRITY](/docs/drs/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)).
```

## comment:3

Above `Mock Get-Config -ModuleName Catzc.Base.Config -MockWith { $script:fixture }`, written with `#`.

```text
The one reader is mocked, never a file, so an address is resolved exactly as it would be against a real
config.
```
