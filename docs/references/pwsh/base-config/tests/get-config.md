# pwsh/Base.Config/tests/Get-Config.Tests.ps1

The L0 tests of `Get-Config`: discovery, memoization, the not-found path, parameter validation, registry validation and the overlay merge.

## Shipped config

One case reads the shipped `tools.yml`, so discovery in its owning module is proven for a real config
([ADR-AUTO-TEST-LOGICANDINTEGRITY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)). The raw default
itself is pinned hermetically, on a fixture config with no registry entry.

## Function behaviour

Memoization, the not-found error path and parameter-binding validation hold whatever configs are shipped. The caching test owns a fixture
config through the `Resolve-ConfigEntry` seam, so it never reads a shipped config
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Registry validation

The validator is exercised on inline, synthetic registries, independent of any shipped `configs.yml`.

## Overlay merge

A bundled config and a consumer overlay are both fixtures behind the `Resolve-ConfigEntry`, overlay-root and registry seams, so a merge is
tested without a real consumer ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)).
