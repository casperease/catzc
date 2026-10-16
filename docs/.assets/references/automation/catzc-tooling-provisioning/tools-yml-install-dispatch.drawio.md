---
catzc:
  immutable:
    with_body_sha: "26b52e084a21"
    path: docs/.assets/references/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.md
    folder: docs/.assets/references/automation/catzc-tooling-provisioning
    name: tools-yml-install-dispatch-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-AUTO-BASH#6
      - ADR-AUTO-DEPS#4
    links:
      - docs/.assets/references/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.png
---

# tools.yml is the one locked list; dispatch is by key name: the diagram described

```text
A 1588 x 592 diagram, read left to right through three bands: CONFIG, READ, DISPATCH.
Glyphs: 5 code units, 2 C# types, 1 file, 1 named set, 1 failure; 2 catzc module frames.
Edges: 10 flow edges (two joined by buses), 1 failure path; 9 markers; 1 count chip.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](tools-yml-install-dispatch.drawio.png) draws from the source of the `Catzc.Tooling.Provisioning` module.
The module's reference article embeds it and gives the responsibility in prose.

## At a glance

`tools.yml` is the one list of version-locked tools in cats. `Get-Config` reads it into a typed `ToolsConfig`, and three readers take that
map: `Get-ToolsStatus` for what is already on the machine, `Get-ToolInstallOrder` for the `depends_on` order, and `Get-ToolConfig` for each
tool's entry. `Install-DevBoxTools` walks the keys in that order and turns each key into a command name with `Get-ToolCommandSuffix`
(`az_cli` becomes `Install-AzCli`). It calls that function, and it throws when no such function exists. Sixteen keys reach the dispatch;
`winget` and `bash` are provided by the platform, so they are asserted and never installed.

## Walkthrough

1. **`tools.yml`** in `Catzc.Base.Execution` locks every managed tool: 18 snake_case keys, each with its version, its manager metadata and
   an optional `depends_on`.
2. **`ToolsConfig`** is the type `Get-Config -Config tools` builds: the keys in file order, each a validated `ToolConfig`, and every
   `depends_on` must name a declared tool (ADR-AUTO-DEPS#4).
3. **`Get-ToolsStatus`** probes every tool and returns one `ToolStatus` each. `Install-DevBoxTools` calls it first and leaves every `Usable`
   tool alone, with a message: it works but no cats manager owns it.
4. **`Get-ToolInstallOrder`** sorts the keys topologically by `depends_on` (Kahn's algorithm) and throws on a cycle. `uv` comes before
   `python`, `node_js` before `cspell`.
5. **`Get-ToolConfig`** hands `Install-DevBoxTools` one key's `ToolConfig`, which decides the skips: not on this platform (`windows_only`),
   platform-provided (`system_provided`, asserted instead), or needs elevation that the session lacks.
6. **`Get-ToolCommandSuffix`** title-cases the key's parts and joins them: `py_spark` becomes `PySpark`, `node_js` becomes `NodeJs`.
7. **`Install-DevBoxTools`** builds `Install-<Suffix>` from the suffix and checks that the function exists.
8. **`Install-<Suffix>`** is the set of per-tool installers it calls, with `-Force` passed through (pip tools take none). The count chip
   says 16 exist, spread over `Catzc.Tooling.Toolchain`, `Catzc.Tooling.Python`, `Catzc.Tooling.Node` and this module (`Install-Zsh`).
9. **`No Install-… function found`** is the throw when a key has no installer. No key reaches it today: each of the 16 dispatched keys has
   its function.

`Install-Git` runs before the walk and `Install-Postman` after it. Neither is version-locked or in tools.yml, so both are cut from the
drawing.

## Reading path

Start at `tools.yml` (marker 1) in the CONFIG band, inside the `Catzc.Base.Execution` frame, and follow the edge down to `ToolsConfig`
(marker 2). One edge leaves `ToolsConfig` to the right and splits on a bus at the left of the READ band into three arrows: up to
`Get-ToolsStatus` (marker 3) and right to `Get-ToolInstallOrder` (marker 4) and `Get-ToolConfig` (marker 5), the last two inside the
`Catzc.Tooling.Core` frame. `Get-ToolsStatus` feeds `ToolStatus` beside it. `ToolStatus` and the three Core functions, including
`Get-ToolCommandSuffix` (marker 6), join a second bus at the right of the READ band, which enters `Install-DevBoxTools` (marker 7) in the
DISPATCH band as one arrow. From there one edge runs right to `Install-<Suffix>` (marker 8), and a red failure path drops and runs right to
the failure glyph (marker 9).

## Glyphs

| Glyph                         | Kind (legend phrase) | Band     | Frame                | Marker |
| ----------------------------- | -------------------- | -------- | -------------------- | ------ |
| `tools.yml`                   | file                 | CONFIG   | Catzc.Base.Execution | 1      |
| `ToolsConfig`                 | C# type              | CONFIG   | Catzc.Base.Execution | 2      |
| `Get-ToolsStatus`             | code unit            | READ     | none                 | 3      |
| `ToolStatus`                  | C# type              | READ     | none                 | —      |
| `Get-ToolInstallOrder`        | code unit            | READ     | Catzc.Tooling.Core   | 4      |
| `Get-ToolConfig`              | code unit            | READ     | Catzc.Tooling.Core   | 5      |
| `Get-ToolCommandSuffix`       | code unit            | READ     | Catzc.Tooling.Core   | 6      |
| `Install-DevBoxTools`         | code unit            | DISPATCH | none                 | 7      |
| `Install-<Suffix>`            | named set            | DISPATCH | none                 | 8      |
| `No Install-… function found` | failure              | DISPATCH | none                 | 9      |

The two catzc module frames are slate outlines with no fill, named top-left. A count chip reading `16` sits on the bottom-right corner of
`Install-<Suffix>`, away from its marker. Each C# type carries a `C#` tag on its top-right corner.

## Edges

Every flow edge means "feeds": data moves along it. Each is backed by a call site in the source.

| From                    | To                     | Call site                                          |
| ----------------------- | ---------------------- | -------------------------------------------------- |
| `tools.yml`             | `ToolsConfig`          | `Get-Config -Config tools`, typed in `configs.yml` |
| `ToolsConfig`           | `Get-ToolsStatus`      | `Get-ToolsStatus.ps1`                              |
| `ToolsConfig`           | `Get-ToolInstallOrder` | `Get-ToolInstallOrder.ps1`                         |
| `ToolsConfig`           | `Get-ToolConfig`       | `Get-ToolConfig.ps1`                               |
| `Get-ToolsStatus`       | `ToolStatus`           | `Get-ToolsStatus.ps1`                              |
| `ToolStatus`            | `Install-DevBoxTools`  | `Install-DevBoxTools.ps1`                          |
| `Get-ToolInstallOrder`  | `Install-DevBoxTools`  | `Install-DevBoxTools.ps1`                          |
| `Get-ToolConfig`        | `Install-DevBoxTools`  | `Install-DevBoxTools.ps1`                          |
| `Get-ToolCommandSuffix` | `Install-DevBoxTools`  | `Install-DevBoxTools.ps1`                          |
| `Install-DevBoxTools`   | `Install-<Suffix>`     | `Install-DevBoxTools.ps1`                          |
| `Install-DevBoxTools`   | failure (failure path) | `Install-DevBoxTools.ps1`                          |

The three edges out of `ToolsConfig` share one bus, and the four edges into `Install-DevBoxTools` share another, entering as one arrow.

## Legend

The legend panel spans the bottom of the drawing area in four columns of two rows:

| Swatch                      | Phrase                                    |
| --------------------------- | ----------------------------------------- |
| slate rounded box           | code unit                                 |
| slate rounded box, `C#` tag | C# type                                   |
| green page, folded corner   | file                                      |
| mauve rounded box           | named set                                 |
| red rounded box             | failure, entered by a red failure path    |
| grey arrow                  | flow: feeds (data moves)                  |
| light disc with a digit     | marker: a Walkthrough step                |
| pill reading `16`           | count chip: Install- functions dispatched |

The catzc module frames name themselves and have no legend row.

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-DEPS#4 and ADR-AUTO-PKGMGR, then ADR-AUTO-ENGINE and
ADR-AUTO-BASH#6: the rules the drawn code and config cite. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

ADR-AUTO-DEPS shows `Install-DevBoxTools` as a hand-written list of `Install-*` calls; the code walks tools.yml in `depends_on` order and
dispatches each key by name, so adding a tool to tools.yml (and its `Install-<Suffix>` function) is the whole change.
