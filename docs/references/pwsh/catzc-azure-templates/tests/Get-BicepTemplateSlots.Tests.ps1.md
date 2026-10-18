# pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-setuponce)/[ADR-AUTO-TEST-SAFESEAMSWAPS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
```

## comment:2

Above `@(Get-BicepTemplateSlots 'sample-customer') | Should -BeNullOrEmpty`, written with `#`.

```text
sample-customer's root config carries no slot; acme MIXES a base config (alpha) and a slotted
one (alpha-001), so only the acme view offers a slot discriminator.
```

## comment:3

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-setuponce)/[ADR-AUTO-TEST-SAFESEAMSWAPS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
```

## comment:4

Above `$commands = @(`, written with `#`.

```text
Every deploy/name path that takes a slot exposes the completer; the private RG helper carries it
too for uniformity. These are the user-facing exported ones the completer actually fires on.
```
