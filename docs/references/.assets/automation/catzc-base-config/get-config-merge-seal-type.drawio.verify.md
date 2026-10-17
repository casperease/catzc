---
catzc:
  immutable:
    with_body_sha: e64cd3135583
    repo_status: clean
    path: docs/.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.verify.md
    folder: docs/.assets/references/automation/catzc-base-config
    name: get-config-merge-seal-type-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-OVERLAY#7
      - ADR-PWSH-CACHE#4
---

# Verification: Overlay merges unless sealed; the registered type builds it (source lens, Catzc.Base.Config)

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's line numbers is reused (for example the cache check
moved from `Get-Config.ps1:62-68` to `:55-63`, and the type construction from `:100-101` to `:84-85`). `condense-comments` may move them
again, so re-grep before landing. Paths are relative to `automation/Catzc.Base.Config/` unless they start with `automation/` or `docs/`.

## Boxes

| #   | Claim (box)                                                                                            | Source (`file:line`)                                                                                         | Status    |
| --- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ | --------- |
| B1  | `Get-Config` is a public function (code unit)                                                          | `Get-Config.ps1:20` at the module root                                                                       | confirmed |
| B2  | `Resolve-ConfigEntry` is private and returns the entry (Name, Module, Path)                            | `private/Resolve-ConfigEntry.ps1:15`; `Get-Config.ps1:38`                                                    | confirmed |
| B3  | `Get-ConfigOverlayRoot` is private and wraps `Get-CatzcOverlayRoot` (build mode)                       | `private/Get-ConfigOverlayRoot.ps1:11,21`; `automation/Catzc.Base.Repository/Get-CatzcOverlayRoot.ps1:18-20` | confirmed |
| B4  | `Get-ConfigRegistry` is private and returns `configs.yml`'s `configs:` map                             | `private/Get-ConfigRegistry.ps1:9,21,27,30-31`                                                               | confirmed |
| B5  | `configs.yml` is the registry: name → `type:` and optional `overridable:`                              | `configs/configs.yml:4-7`                                                                                    | confirmed |
| B6  | Gate `overridable: false?`: sealed only when a fragment exists and the entry says `overridable: false` | `Get-Config.ps1:100-102`                                                                                     | confirmed |
| B7  | Failure `sealed: throw`: "Config '…' is sealed (configs.yml overridable: false) …"                     | `Get-Config.ps1:103`                                                                                         | confirmed |
| B8  | `Merge-ConfigFragment` is private: null removes a key, maps recurse, else replace                      | `private/Merge-ConfigFragment.ps1:13,30-37`                                                                  | confirmed |
| B9  | The fragment is `<overlay root>/<Module>/configs/<name>.yml`                                           | `Get-Config.ps1:47-49`                                                                                       | confirmed |
| B10 | `$type::new($raw)`: the registered C# type builds and validates the merged map                         | `Get-Config.ps1:82-85` (`[type] $registered['type']`)                                                        | confirmed |

## Edges (flow: runs next, in code order)

| #   | Edge                                                             | Source (`file:line`)                                                                                            | Status    |
| --- | ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------- |
| E1  | `Get-Config` → `Resolve-ConfigEntry`                             | `Get-Config.ps1:38`                                                                                             | confirmed |
| E2  | `Resolve-ConfigEntry` → `Get-ConfigOverlayRoot`                  | `Get-Config.ps1:38,45`                                                                                          | confirmed |
| E3  | `Get-ConfigOverlayRoot` → `Get-ConfigRegistry` (into CACHE MISS) | `Get-Config.ps1:45,68`; a cache hit returns at `:61-63` first, and the bundled config is read at `:65-66` (cut) | confirmed |
| E4  | `Get-ConfigRegistry` → gate                                      | `Get-Config.ps1:99-102`                                                                                         | confirmed |
| E5  | gate → `sealed: throw` (failure path)                            | `Get-Config.ps1:102-103`                                                                                        | confirmed |
| E6  | gate → `Merge-ConfigFragment`                                    | `Get-Config.ps1:73-76` (after the both-maps assert at `:74`; skipped for an empty fragment at `:75`)            | confirmed |
| E7  | `Merge-ConfigFragment` → `$type::new($raw)`                      | `Get-Config.ps1:76,84-85`                                                                                       | confirmed |

## Bands and other claims

| #   | Claim                                                                                                  | Source (`file:line`)                                                                                                                                                                                                   | Status       |
| --- | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | RESOLVE: the cache key is the config path, plus the fragment path and its stamp when a fragment exists | `Get-Config.ps1:44,50-51` (`LastWriteTimeUtc.Ticks`, `Length`)                                                                                                                                                         | confirmed    |
| C2  | CACHE MISS: registry, gate, merge and type run only when the key is not cached                         | `Get-Config.ps1:61-63` before `:65-89`                                                                                                                                                                                 | confirmed    |
| C3  | The result is cached under that key and returned                                                       | `Get-Config.ps1:89-90`                                                                                                                                                                                                 | confirmed    |
| C4  | No fragment (no overlay, or no file): the gate and merge are skipped; the type still builds            | `Get-Config.ps1:46-48,69,81-85`                                                                                                                                                                                        | confirmed    |
| C5  | An unregistered config returns the raw map, unbuilt                                                    | `Get-Config.ps1:81-82`                                                                                                                                                                                                 | confirmed    |
| C6  | Five configs are sealed: configs, glossary, dependencies, profiles, exporter                           | `configs/configs.yml:7,38,47,52,65`                                                                                                                                                                                    | confirmed    |
| C7  | The registry is validated by `ConfigsConfig` when read                                                 | `private/Get-ConfigRegistry.ps1:28`                                                                                                                                                                                    | confirmed    |
| C8  | ADR: `Catzc.Base.Config` refuses a sealed fragment via `ConfigsConfig.sealedConfigs`                   | `docs/adr/automation/consumer-overlay.md:186-187`; `Get-Config.ps1:101-102` (reads `sealedConfigs`); `automation/Catzc.Base.Overlay/Assert-CatzcOverlay.ps1:56` (reads it the same way)                                  | confirmed    |
| C9  | ADR-AUTO-OVERLAY#7: sealed configs are declared once in the registry (`overridable: false`)            | `docs/adr/automation/consumer-overlay.md:57-61`; `configs/configs.yml`                                                                                                                                                 | confirmed    |
| C10 | Supports: ADR-AUTO-OVERLAY, ADR-PWSH-CACHE#4, ADR-AUTO-ASSETDEP#1, cited by the drawn code             | `Get-Config.ps1:41,57`; `private/Merge-ConfigFragment.ps1:6`; `private/Get-ConfigRegistry.ps1:6,14`; `configs/configs.yml:2`                                                                                           | confirmed    |

Counts: 27 claims, 26 confirmed, 1 contradicted, 0 ADR-only.

## Corrections

- The brief's sketch put the cache check before `Get-ConfigRegistry`; the code computes the overlay root and the cache key first (`:43-53`),
  then checks the cache (`:61`). The slide shows the cache as the boundary between the RESOLVE and CACHE MISS bands, not as a box: a store
  would be a fifth kind, and the caches have their own slide (`adr-conf-loading--three-caches-back-one-reader`).
- `Get-ConfigOverlayRoot` is not in the brief's sketch; it is the step that decides whether a fragment can exist, so it is drawn.
- The seal check is a lookup of `ConfigsConfig.sealedConfigs` built from the registry (`Get-Config.ps1:101`), so it needs no second box.
- Every scout line number had moved after the comment export. All the numbers above are new.

## Drift

- The sealed throw cites no rule code; ADR-AUTO-OVERLAY#7 is the rule it enforces.

## Cut

The cache store `$script:configCache` (`:55-63,89-90`, the caches slide owns it), `Assert-PathExist` and the bundled `configs/<name>.yml`
read (`:65-66`), the both-maps `Assert-True` (`:74`), `ConfigsConfig` (`private/Get-ConfigRegistry.ps1:28`), `Get-CatzcOverlayRoot` in
`Catzc.Base.Repository`, the `-ListOwners` path (`:34-36`) and the `configs.yml` count (5 sealed of 49 registered), each one more box, kind
or chip past the caps; the description names them.
