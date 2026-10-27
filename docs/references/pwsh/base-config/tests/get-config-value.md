# pwsh/Base.Config/tests/Get-ConfigValue.Tests.ps1

The tests of `Get-ConfigValue`: address resolution over a fixture config, and one case over the real wiring.

## Mocked reader

`Get-ConfigValue` reads through `Get-Config` ([ADR-CONF-LOADING-CONFIGONEREADER][r1]), so the tests mock the reader and never a file. An
address resolves exactly as it would against a real config.

## Real wiring

One case reads the shipped `tools.yml`, which loads as the typed `ToolsConfig`, a read-only tool map, and guards the wiring end to end
([ADR-AUTO-TEST-TWOMANDATORYTAGS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags)).

[r1]: ../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-configonereader
