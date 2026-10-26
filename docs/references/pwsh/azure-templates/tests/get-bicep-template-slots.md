# pwsh/Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1

The L0 tests of the template-slots function and of the slot completer the commands expose.

## Setup once

These are read-only resolver tests. In both blocks the boundary mocks and the config-cache reset run once, not per test: the mocked config
is identical for every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

## Mixed and base-only customers

`sample-customer`'s root config carries no slot. The customer `acme` mixes a base config (`alpha`) and a slotted one (`alpha-001`), so only
the `acme` view offers a slot discriminator.

## The completer

Every deploy and name path that takes a slot exposes the completer, and the private resource-group helper carries it too for uniformity. The
tests cover the user-facing exported commands the completer actually fires on.
