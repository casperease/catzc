---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/tests/Get-Config.Tests.ps1.md
    kind: test-asset
    body_sha: "77388033d757"
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `It 'discovers and loads a shipped config from its owning module' {`.

```text
Reads the shipped tools.yml — guards that a real config is discovered in its owning module and loads
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The raw default itself
is pinned hermetically below, on a fixture config with no registry entry.
```

## comment:2

Above `It 'returns the same cached object reference on repeat calls' {`.

```text
Function behaviour, independent of which configs are shipped: memoization, the not-found error
path, and parameter-binding validation
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The caching test owns a
fixture config
through the Resolve-ConfigEntry seam, so it never reads a shipped config
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:3

Above `BeforeEach {`.

```text
A bundled config and a consumer overlay, both fixtures, through the Resolve-ConfigEntry, overlay-root and
registry seams ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)).
```

## comment:4

Above `It 'accepts a valid registry (one type per entry)' {`.

```text
Validator logic on inline (synthetic) registries — independent of any shipped configs.yml
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```
