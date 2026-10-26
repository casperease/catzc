# pwsh/Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)/[ADR-AUTO-TEST-SAFESEAMSWAPS](/docs/drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
```

## comment:2

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)/[ADR-AUTO-TEST-SAFESEAMSWAPS](/docs/drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
```

## comment:3

Above `$commands = @(`, written with `#`.

```text
The naming and file-addressing paths take -Customer (the deploy paths are session-determined);
each exposes the completer over Get-BicepTemplateCustomers.
```
