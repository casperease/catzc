# One quality gate guards the config read path, and it checks only the typed step

```text
One quality gate guards the config read path, and it checks only the typed step.

1  one reader              every read goes through Get-Config (L1, L6); convention only
2  resolution              name discovered, address walked (L2, A1, A2, A4); runtime throws
3  session cache           one cache keyed by file path (L3); held by the code
4  a read, not a copy      a resolved node is never mutated (A3, A5); convention only
5  PowerShell validator    the extension point outside Get-Config (L5); no validator yet
6  typed once              the registered C# type validates the whole config (L4)
7  Test-ConfigValidators   the gate for the extension point (L5, T35)
8  Test-ShippedConfigs     the gate for the typed step (L4, T35)

Supports ADR-CONF-LOADING-CONFIGONEREADER, ADR-CONF-LOADING-READINGISGLOBAL, ADR-CONF-LOADING-EXISTENCEDISCOVERED,
ADR-CONF-ADDRESSING-GLOBALADDRESSFORM, ADR-CONF-ADDRESSING-FIRSTSEGMENTISCONFIG, ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST,
ADR-CONF-LOADING-CACHEBYPATH, ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY, ADR-CONF-ADDRESSING-RESOLVEDNODEISREAD,
ADR-CONF-LOADING-POWERSHELLVALIDATOR, ADR-CONF-LOADING-CSHARPCONFIGTYPE and ADR-AUTO-TEST-QUALITYGATE (governance lens).
```

Three ADRs constrain how cats reads a config: the loading ADR, the addressing ADR, and the test-automation rule that every quality gate runs
in an integrity test. Each stage of the read path carries the rules that govern it, set against what actually checks them. One quality gate,
`Test-ShippedConfigs`, guards the read path, and it looks only at the typed step; the one-reader rule and the read-only rule rest on
convention.

```yml drawio
description:
  "Each stage of the config read path with the rules that govern it and what actually checks them: one quality gate guards the typed step
  and one the validator extension point, while the one-reader and read-only rules rest on convention."
about:
  adrs:
    - ADR-CONF-LOADING-CONFIGONEREADER
    - ADR-CONF-LOADING-READINGISGLOBAL
    - ADR-CONF-LOADING-EXISTENCEDISCOVERED
    - ADR-CONF-ADDRESSING-GLOBALADDRESSFORM
    - ADR-CONF-ADDRESSING-FIRSTSEGMENTISCONFIG
    - ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST
    - ADR-CONF-LOADING-CACHEBYPATH
    - ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY
    - ADR-CONF-ADDRESSING-RESOLVEDNODEISREAD
    - ADR-CONF-LOADING-POWERSHELLVALIDATOR
    - ADR-CONF-LOADING-CSHARPCONFIGTYPE
    - ADR-AUTO-TEST-QUALITYGATE
  lens: governance
content:
  title: One quality gate guards the config read path, and it checks only the typed step
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-read, label: READ PATH }
    - { id: band-miss, label: MISS }
    - { id: band-extension, label: EXTENSION POINT }
    - { id: band-gates, label: QUALITY GATES }
  glyphs:
    - { id: a-reader, kind: drsonly, label: one reader, in: band-read }
    - { id: g-resolution, kind: code, label: resolution, in: band-read }
    - { id: s-cache, kind: store, label: session cache, in: band-read }
    - { id: a-copy, kind: drsonly, label: "a read, not a copy", in: band-read }
    - { id: g-typed, kind: code, label: typed once, in: band-miss }
    - { id: a-validator, kind: drsonly, label: PowerShell validator, in: band-extension }
    - { id: g-validators, kind: gate, label: Test-ConfigValidators, in: band-gates }
    - { id: g-shipped, kind: gate, label: Test-ShippedConfigs, in: band-gates }
  edges:
    - { from: a-reader, to: g-resolution, kind: flow, label: calls }
    - { from: g-resolution, to: s-cache, kind: flow, label: "" }
    - { from: s-cache, to: g-typed, kind: flow, label: feeds }
    - { from: g-typed, to: a-copy, kind: flow, label: "" }
    - { from: g-validators, to: a-validator, kind: flow, label: "" }
    - { from: g-shipped, to: g-typed, kind: flow, label: calls }
  markers:
    - { at: a-reader, number: 1 }
    - { at: g-resolution, number: 2 }
    - { at: s-cache, number: 3 }
    - { at: a-copy, number: 4 }
    - { at: a-validator, number: 5 }
    - { at: g-typed, number: 6 }
    - { at: g-validators, number: 7 }
    - { at: g-shipped, number: 8 }
  chips:
    - { at: a-reader, kind: rule, rule: ADR-CONF-LOADING-CONFIGONEREADER, gated: false }
    - { at: a-reader, kind: rule, rule: ADR-CONF-LOADING-READINGISGLOBAL, gated: false }
    - { at: g-resolution, kind: rule, rule: ADR-CONF-LOADING-EXISTENCEDISCOVERED }
    - { at: g-resolution, kind: rule, rule: ADR-CONF-ADDRESSING-GLOBALADDRESSFORM }
    - { at: g-resolution, kind: rule, rule: ADR-CONF-ADDRESSING-FIRSTSEGMENTISCONFIG }
    - { at: g-resolution, kind: rule, rule: ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST }
    - { at: s-cache, kind: rule, rule: ADR-CONF-LOADING-CACHEBYPATH }
    - { at: a-copy, kind: rule, rule: ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY, gated: false }
    - { at: a-copy, kind: rule, rule: ADR-CONF-ADDRESSING-RESOLVEDNODEISREAD, gated: false }
    - { at: a-validator, kind: rule, rule: ADR-CONF-LOADING-POWERSHELLVALIDATOR, gated: false }
    - { at: g-typed, kind: rule, rule: ADR-CONF-LOADING-CSHARPCONFIGTYPE }
    - { at: g-validators, kind: rule, rule: ADR-CONF-LOADING-POWERSHELLVALIDATOR }
    - { at: g-validators, kind: rule, rule: ADR-AUTO-TEST-QUALITYGATE }
    - { at: g-shipped, kind: rule, rule: ADR-CONF-LOADING-CSHARPCONFIGTYPE }
    - { at: g-shipped, kind: rule, rule: ADR-AUTO-TEST-QUALITYGATE }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-read: { x: 20, y: 100, w: 600, h: 400 }
  band-extension: { x: 640, y: 100, w: 640, h: 120 }
  band-gates: { x: 640, y: 240, w: 640, h: 130 }
  band-miss: { x: 640, y: 390, w: 640, h: 120 }
  a-reader: { x: 170, y: 146, w: 300, h: 44 }
  g-resolution: { x: 170, y: 226, w: 300, h: 44 }
  s-cache: { x: 430, y: 306, w: 160, h: 60 }
  a-copy: { x: 170, y: 436, w: 300, h: 44 }
  a-validator: { x: 650, y: 146, w: 300, h: 44 }
  g-validators: { x: 700, y: 280, w: 240, h: 68 }
  g-shipped: { x: 1000, y: 280, w: 220, h: 68 }
  g-typed: { x: 650, y: 436, w: 600, h: 44 }
```

![One quality gate guards the config read path](.assets/one-gate-guards-the-read-path.drawio.png)

In the walkthrough, `L` is ADR-CONF-LOADING, `A` is ADR-CONF-ADDRESSING and `T` is ADR-AUTO-TEST; the diagram's rule chips are keyed in its
legend.

## Walkthrough

1. **one reader.** Every config read goes through `Get-Config`, and only `Get-Config` is public (L1, L6). No analyzer rule or quality gate
   looks for a direct config read, and two functions read config files themselves today: `Get-ConfigRegistry` reads `configs.yml` and keeps
   its own `$script:` cache, and `Test-ConfigIdentityHygiene` parses every module's `configs/*.yml` directly.
2. **resolution.** The name is discovered and the address is walked (L2, A1, A2, A4). Runtime throws check this stage: a `ValidatePattern`
   rejects a malformed address at binding, `Resolve-ConfigEntry` throws on an unknown or ambiguous name, and the key walk throws on a
   segment that is neither a key nor a property.
3. **session cache.** One cache keyed by file path, invalidated only by re-import (L3). The code holds this rule, and an L0 logic test pins
   the same reference on repeat calls.
4. **a read, not a copy.** A resolved node may be a live reference into the cache, and it must never be mutated (A3, A5). Nothing stops a
   caller from changing it; committed config is the only thing an address can reach, so secrets have no address by construction.
5. **PowerShell validator.** The extension point for owners that cannot ship a C# type: `Invoke-ConfigValidator` runs an
   `Assert-<Name>Config` in its owning module's scope (L5). No such validator exists outside test fixtures, and nothing outside its own
   tests calls `Invoke-ConfigValidator`.
6. **typed once.** On the miss, the registered C# type is constructed once and validates the whole config (L4). This is where the read
   path's gate looks.
7. **Test-ConfigValidators.** The gate for the extension point (L5, T35): every `Assert-*Config` must map to a shipped config of its module.
   An L0 integrity test runs it, so it is wired into every test run, but today it has no validator to check.
8. **Test-ShippedConfigs.** The gate for the typed step (L4, T35), run by an L0 integrity test in every test run. It reports a shipped
   config without a type, a registry entry without a shipped config, a type that does not resolve, and a config that does not load, and
   writes its report to `out/test-shipped-configs/`.

## Why it holds

- All config reads go through `Get-Config`, and only `Get-Config` is public (ADR-CONF-LOADING-CONFIGONEREADER,
  ADR-CONF-LOADING-READINGISGLOBAL).
- A config is discovered from its folder; an unknown or ambiguous name throws (ADR-CONF-LOADING-EXISTENCEDISCOVERED).
- The cache is keyed by resolved path and cleared only by re-import (ADR-CONF-LOADING-CACHEBYPATH).
- Every shipped config has a registered C# type, and `Test-ShippedConfigs` is its gate (ADR-CONF-LOADING-CSHARPCONFIGTYPE).
- A PowerShell validator is the extension point outside `Get-Config`, and `Test-ConfigValidators` is its gate
  (ADR-CONF-LOADING-POWERSHELLVALIDATOR).
- An address names one node, its first segment is the config's global name, and resolution fails fast
  (ADR-CONF-ADDRESSING-GLOBALADDRESSFORM, ADR-CONF-ADDRESSING-FIRSTSEGMENTISCONFIG, ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST).
- Only committed config is addressable, and a resolved node is a read, never mutated (ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY,
  ADR-CONF-ADDRESSING-RESOLVEDNODEISREAD).
- Every quality gate runs in an integrity test at its tier (ADR-AUTO-TEST-QUALITYGATE).

## Where the code and the decision record differ

- The one-reader rule has two exceptions the ADR does not state: `Get-ConfigRegistry` reads `configs.yml` and caches it itself, and
  `Test-ConfigIdentityHygiene` parses module configs directly.
- The ADR says only `Get-Config` is public; `Catzc.Base.Config` also exports `Get-ConfigValue`, which the addressing ADR sanctions.
- An address key cannot contain a dot, because `Get-ConfigValue` splits the address on every dot; the addressing ADR does not say so.

## See also

- [Module config loading](../../drs/configuration/module-config-loading.md) — the decision this article explains.
- [Config value addressing](../../drs/configuration/config-value-addressing.md) and
  [test automation](../../drs/automation/test-automation.md) — the other rules on the diagram.
- The other lenses on the same read path: [meta](one-reader-one-cache-per-session.md),
  [architecture](callers-depend-on-one-config-module.md), [implementation](three-caches-back-one-reader.md) and
  [operations](ask-by-name-get-the-cached-object.md).
- [The configuration explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
