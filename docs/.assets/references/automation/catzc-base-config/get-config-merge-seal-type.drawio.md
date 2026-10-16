---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "41345f139c1c"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-OVERLAY#7
      - ADR-PWSH-CACHE#4
    links:
      - docs/.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.png
---

# Overlay merges unless sealed; the registered type builds it: the diagram described

```text
A 1588 x 592 diagram, read left to right through two bands, top to bottom.
Glyphs: 1 code unit, 4 private helpers, 1 C# type, 2 files, 1 gate, 1 failure; 7 flow edges (1 red); 8 markers.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](get-config-merge-seal-type.drawio.png) draws from the source of the `Catzc.Base.Config` module. The
module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every config read in cats goes through `Get-Config`. It resolves the config's name to one entry and asks whether a consumer overlay exists;
when the overlay holds a fragment of this config, the fragment's path and stamp (last write time and length) join the cache key, so an
edited fragment is a new key. Only on a cache miss does the rest run: the registry is read, a fragment of a sealed config
(`overridable: false`) throws, any other fragment is merged onto the bundled config, and the registered C# type builds and validates the
result. The caches themselves are drawn on their own slide, `adr-conf-loading--three-caches-back-one-reader`.

## Walkthrough

1. **`Get-Config`** is the single public reader of a module's `configs/<name>.yml`.
2. **`Resolve-ConfigEntry`** turns the global lowercase name (and `-Module`, when two modules ship it) into one entry: name, module and
   path. It throws when no module, or more than one, ships the config.
3. **`Get-ConfigOverlayRoot`** returns the overlay root, which `Get-CatzcOverlayRoot` (`Catzc.Base.Repository`) derives in build mode only.
   A fragment is `<overlay root>/<Module>/configs/<name>.yml`; when it exists, its path and stamp join the cache key. A cached key returns
   here, which is why the next band is CACHE MISS.
4. **`Get-ConfigRegistry`** reads `configs.yml`, the file below it: each shipped config's C# type (`type:`) and, for five engine configs,
   `overridable: false`. `ConfigsConfig` validates the registry on that read.
5. **The `overridable: false?` gate** applies only when a fragment exists. Without one, the flow skips the gate and the merge and goes
   straight to the type.
6. **`sealed: throw`**: a fragment of a sealed config is refused with "Config '…' is sealed (configs.yml overridable: false), so the overlay
   may not change it: remove …".
7. **`Merge-ConfigFragment`** merges the fragment, the file below it, onto the bundled config key by key: a null removes a key, a map merges
   recursively, anything else replaces. Both must be maps, or `Get-Config` asserts.
8. **`$type::new($raw)`** builds the registered C# type from the merged map; its constructor maps and validates it. An unregistered config
   is returned as the raw map. The result is cached under the key from step 3.

## Reading path

Start at `Get-Config` on the left of the RESOLVE band and follow the flow right through `Resolve-ConfigEntry` to `Get-ConfigOverlayRoot`.
From there one edge drops out of the band and runs left, then down into `Get-ConfigRegistry` at the start of the CACHE MISS band. Follow
that band right through the gate and `Merge-ConfigFragment` to `$type::new($raw)`. The red edge drops from the gate to `sealed: throw`. The
two files sit under the steps that read them.

## Glyphs

| Glyph                         | Kind           | Band       | Marker |
| ----------------------------- | -------------- | ---------- | ------ |
| `Get-Config`                  | code unit      | RESOLVE    | 1      |
| `Resolve-ConfigEntry`         | private helper | RESOLVE    | 2      |
| `Get-ConfigOverlayRoot`       | private helper | RESOLVE    | 3      |
| `Get-ConfigRegistry`          | private helper | CACHE MISS | 4      |
| `configs.yml`                 | file           | CACHE MISS | —      |
| `overridable: false?`         | gate           | CACHE MISS | 5      |
| `sealed: throw`               | failure        | CACHE MISS | 6      |
| `Merge-ConfigFragment`        | private helper | CACHE MISS | 7      |
| `<Module>/configs/<name>.yml` | file           | CACHE MISS | —      |
| `$type::new($raw)`            | C# type        | CACHE MISS | 8      |

`configs.yml` sits directly under `Get-ConfigRegistry` and the fragment file directly under `Merge-ConfigFragment`, with no edge: the flow
edge means "runs next", and a file does not run. Private helpers have a darker fill than the code unit; the C# type carries a `C#` tag on
its top-right corner.

## Edges

Every grey edge is a flow edge meaning "runs next, in code order"; the red edge is the failure path. Each is backed by a call site in
`Get-Config.ps1`.

| From                    | To                      | Call site                                                   |
| ----------------------- | ----------------------- | ----------------------------------------------------------- |
| `Get-Config`            | `Resolve-ConfigEntry`   | `Get-Config.ps1`, the entry resolve                         |
| `Resolve-ConfigEntry`   | `Get-ConfigOverlayRoot` | `Get-Config.ps1`, the overlay root, before the cache key    |
| `Get-ConfigOverlayRoot` | `Get-ConfigRegistry`    | `Get-Config.ps1`, after the cache check (across the bands)  |
| `Get-ConfigRegistry`    | `overridable: false?`   | `Get-Config.ps1`, the registry entry, then the sealed check |
| `overridable: false?`   | `sealed: throw`         | `Get-Config.ps1`, the throw (red)                           |
| `overridable: false?`   | `Merge-ConfigFragment`  | `Get-Config.ps1`, the fragment parse and merge              |
| `Merge-ConfigFragment`  | `$type::new($raw)`      | `Get-Config.ps1`, the type construction                     |

The line numbers are in the verification file.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- private helper
- C# type
- file
- gate
- failure (red edge: the throw)
- flow: runs next (code order)
- marker: a Walkthrough step

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-OVERLAY, ADR-PWSH-CACHE#4 and ADR-AUTO-ASSETDEP#1:
the rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

ADR-AUTO-OVERLAY says `Catzc.Base.Config` refuses a fragment of a sealed config through `ConfigsConfig.sealedConfigs`. `Get-Config` reads
`overridable` from the registry entry itself; only `Assert-CatzcOverlay` in `Catzc.Base.Overlay` reads `sealedConfigs`. Both readers take
the same declaration in `configs.yml`, as ADR-AUTO-OVERLAY#7 requires, so the behaviour matches and only the named mechanism differs. The
sealed throw cites no rule code.
