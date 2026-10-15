---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md
    kind: test-asset
    body_sha: ee0e2e40c4f4
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---

# automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:2

Above `@(Get-BicepTemplateSlots 'sample-customer') | Should -BeNullOrEmpty`.

```text
sample-customer's root config carries no slot; acme MIXES a base config (alpha) and a slotted
one (alpha-001), so only the acme view offers a slot discriminator.
```

## comment:3

Above `BeforeAll {`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:4

Above `$commands = @(`.

```text
Every deploy/name path that takes a slot exposes the completer; the private RG helper carries it
too for uniformity. These are the user-facing exported ones the completer actually fires on.
```
