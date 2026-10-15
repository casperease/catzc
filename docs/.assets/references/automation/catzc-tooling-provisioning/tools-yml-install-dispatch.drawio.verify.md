# docs/.assets/references/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md

`out/diagrams/wave-9/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md`

`Verification: tools.yml is the one locked list; dispatch is by key name (source lens, Catzc.Tooling.Provisioning)`

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's numbers is reused (for example
`Get-ToolConfig.ps1:15,21` is now `:102,106`, and `Get-ToolCommandSuffix.ps1:23-24` is now `:127-128`). `condense-comments` may move them
again, so re-grep before landing. Paths are relative to `automation/` unless they start with `docs/`.

## Boxes

| #   | Claim (box)                                                                                                      | Source (`file:line`)                                                                                                                                                                                                                                     | Status    |
| --- | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| B1  | `tools.yml` is a file of `Catzc.Base.Execution` with 18 tool keys                                                | `Catzc.Base.Execution/configs/tools.yml:1,13,41,74,86,101,122,132,154,162,172,180,193,206,223,241,260,273`                                                                                                                                               | confirmed |
| B2  | `ToolsConfig` is the C# type `Get-Config -Config tools` builds: key → `ToolConfig`, in file order                | `Catzc.Base.Config/configs/configs.yml:43-44`; `Catzc.Base.Execution/types/ToolsConfig.cs:1,13,49`                                                                                                                                                       | confirmed |
| B3  | `Get-ToolsStatus` is a public function of the slide's module                                                     | `Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1:12`                                                                                                                                                                                                      | confirmed |
| B4  | `ToolStatus` is a C# type of the slide's module                                                                  | `Catzc.Tooling.Provisioning/types/ToolStatus.cs:6,8`                                                                                                                                                                                                     | confirmed |
| B5  | `Get-ToolInstallOrder` (Catzc.Tooling.Core) sorts the keys by `depends_on`                                       | `Catzc.Tooling.Core/Get-ToolInstallOrder.ps1:22,61-74`; throws on a cycle `:76-78`                                                                                                                                                                       | confirmed |
| B6  | `Get-ToolConfig` (Catzc.Tooling.Core) returns one key's `ToolConfig`                                             | `Catzc.Tooling.Core/Get-ToolConfig.ps1:96,102-106`                                                                                                                                                                                                       | confirmed |
| B7  | `Get-ToolCommandSuffix` (Catzc.Tooling.Core) title-cases a snake_case key                                        | `Catzc.Tooling.Core/Get-ToolCommandSuffix.ps1:127-128`                                                                                                                                                                                                   | confirmed |
| B8  | `Install-DevBoxTools` is a public function of the slide's module                                                 | `Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1:14`                                                                                                                                                                                                  | confirmed |
| B9  | `Install-<Suffix>`: one function per dispatched key (Glob `automation/Catzc.*/Install-*.ps1`)                    | zsh→`Catzc.Tooling.Provisioning/Install-Zsh.ps1`; python, poetry, py_spark→`Catzc.Tooling.Python/`; dotnet, az_cli, terraform, java, go, shellcheck, bicep, uv→`Catzc.Tooling.Toolchain/`; node_js, cspell, markdownlint, prettier→`Catzc.Tooling.Node/` | confirmed |
| B10 | A key with no `Install-` function throws `No Install-… function found`                                           | `Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1:75-78`                                                                                                                                                                                               | confirmed |
| B11 | Count chip `16`: 18 keys minus the 2 `system_provided` keys (winget, bash), which are asserted, never dispatched | `tools.yml:6,18`; `Install-DevBoxTools.ps1:47-54`                                                                                                                                                                                                        | confirmed |
| F1  | Frame `Catzc.Base.Execution` holds `tools.yml` and `ToolsConfig`                                                 | `Catzc.Base.Execution/configs/tools.yml`; `Catzc.Base.Execution/types/ToolsConfig.cs:11`                                                                                                                                                                 | confirmed |
| F2  | Frame `Catzc.Tooling.Core` holds the three readers                                                               | `Catzc.Tooling.Core/Get-ToolInstallOrder.ps1`, `Get-ToolConfig.ps1`, `Get-ToolCommandSuffix.ps1`                                                                                                                                                         | confirmed |

The brief's doubt resolved: every tools.yml key has an `Install-<Suffix>` function except `winget` and `bash`, and both are
`system_provided`, so `Install-DevBoxTools` asserts them (`:47-54`) and `continue`s before the dispatch. No key reaches the throw today.

## Edges (flow: feeds, data moves)

| #   | Edge                                            | Source (`file:line`)                                                                        | Status    |
| --- | ----------------------------------------------- | ------------------------------------------------------------------------------------------- | --------- |
| E1  | `tools.yml` → `ToolsConfig`                     | `Catzc.Base.Config/configs/configs.yml:44` (the type `Get-Config -Config tools` constructs) | confirmed |
| E2  | `ToolsConfig` → `Get-ToolsStatus`               | `Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1:16,70-71`                                   | confirmed |
| E3  | `ToolsConfig` → `Get-ToolInstallOrder`          | `Catzc.Tooling.Core/Get-ToolInstallOrder.ps1:15,22`                                         | confirmed |
| E4  | `ToolsConfig` → `Get-ToolConfig`                | `Catzc.Tooling.Core/Get-ToolConfig.ps1:102,106`                                             | confirmed |
| E5  | `Get-ToolsStatus` → `ToolStatus`                | `Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1:138,200`                                    | confirmed |
| E6  | `ToolStatus` → `Install-DevBoxTools`            | `Install-DevBoxTools.ps1:25-29` (`Usable` tools are reported and left alone)                | confirmed |
| E7  | `Get-ToolInstallOrder` → `Install-DevBoxTools`  | `Install-DevBoxTools.ps1:37`                                                                | confirmed |
| E8  | `Get-ToolConfig` → `Install-DevBoxTools`        | `Install-DevBoxTools.ps1:38` (and `:67` for a skipped dependency)                           | confirmed |
| E9  | `Get-ToolCommandSuffix` → `Install-DevBoxTools` | `Install-DevBoxTools.ps1:75`                                                                | confirmed |
| E10 | `Install-DevBoxTools` → `Install-<Suffix>`      | `Install-DevBoxTools.ps1:82,85` (`& $installCmd`, with `-Force` unless a pip tool)          | confirmed |
| E11 | failure path `Install-DevBoxTools` → throw      | `Install-DevBoxTools.ps1:76-77`                                                             | confirmed |

## Other claims

| #   | Claim                                                                                                 | Source (`file:line`)                                                                                                                                                             | Status       |
| --- | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | Install order is the `depends_on` topological sort                                                    | `docs/adr/automation/controlling-systemwide-deps.md:30-33` (ADR-AUTO-DEPS:4); `Get-ToolInstallOrder.ps1:61-74`                                                                   | confirmed    |
| C2  | Supports: ADR-AUTO-DEPS#4, ADR-AUTO-PKGMGR, ADR-AUTO-ENGINE, ADR-AUTO-BASH#6, cited by the drawn code | `ToolsConfig.cs:2`; `docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md` comment:2 ("See ADR: use-proper-package-managers"); `tools.yml:43-44,225` | confirmed    |
| C3  | Brief: "tools.yml is the only list of tools"                                                          | `Install-DevBoxTools.ps1:33,90`: `Install-Git` and `Install-Postman` are called by name, "not version-locked, not in tools.yml"                                                  | contradicted |
| C4  | ADR-AUTO-DEPS §4 draws `Install-DevBoxTools` as a fixed list of `Install-*` calls                     | `docs/adr/automation/controlling-systemwide-deps.md:262-268` vs `Install-DevBoxTools.ps1:37,75-86`                                                                               | contradicted |

Counts: 28 claims, 26 confirmed, 2 contradicted, 0 ADR-only.

## Corrections

- The brief's title said tools.yml is "the only list of tools". `Install-Git` (`:33`) and `Install-Postman` (`:90`) sit outside it by
  design, so the title says "the one locked list".
- The brief's sketch had `ToolConfig` as the type read from tools.yml. `Get-Config -Config tools` builds `ToolsConfig` (configs.yml:44), a
  map of `ToolConfig` entries; all three readers take the map, and `Get-ToolConfig` hands one `ToolConfig` on. The slide draws
  `ToolsConfig`.
- The scout's `Get-ToolCommandSuffix → Install-*` chain is drawn as data: the suffix feeds `Install-DevBoxTools`, which builds the name and
  calls it (`:75,82,85`). The slide's one edge meaning is `flow: feeds`.

## Drift

- ADR-AUTO-DEPS §4 ("Orchestrate with Install-DevBoxTools", controlling-systemwide-deps.md:262-268) shows the orchestrator as hand-written
  `Install-Python; Install-Poetry; Install-Dotnet` calls. The code walks tools.yml in `depends_on` order and dispatches each key by name.
- `Get-ToolInstallOrder.ps1:34-53` keeps a first in-degree pass the code itself calls wrong ("Wait — in-degree is wrong above … Redo
  properly") and then recomputes: dead code against ADR-PRIN-ONELIVE. Its `.EXAMPLE` (`:9`) lists `python` first, although `python`
  `depends_on: uv` (tools.yml:81).
- `Get-ToolInstallOrder` builds `$dependencies` as a plain hashtable (`:18`), so ties in the sort follow hashtable order, not the file order
  `ToolsConfig` keeps (ToolsConfig.cs:1). Not drawn; noted for the lead.

## Cut

`Uninstall-Chocolatey` (`:22`), `Install-Git` (`:33`) and `Install-Postman` (`:90`), the `windows_only`, `system_provided`, elevation and
skipped-dependency branches (`:41-73`, with `Test-Tool`, `Test-ToolRequiresElevation`, `Test-IsAdministrator`, `Test-Command`), `Get-Config`
(Catzc.Base.Config) as its own box, and the per-tool `ToolConfig`. Each is one more box past the cap of 10; the description names them.
