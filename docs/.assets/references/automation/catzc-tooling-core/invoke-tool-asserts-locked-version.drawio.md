---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
    kind: asset-description
    body_sha: "26e79173250c"
    adrs:
      - ADR-AUTO-DEPS#3
      - ADR-AUTO-DRYRUN#2
      - ADR-CONF-LOADING#6
      - ADR-PWSH-CACHE#4
    links:
      - docs/.assets/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.png
---

# Each `Invoke-<Tool>` asserts the locked version before it runs: the diagram described

```text
A 1588 x 672 diagram, read left to right in two rows, with a band above a module frame.
Glyphs: 6 code units, 1 private helper, 1 named set, 1 file, 1 catzc module frame; 8 flow edges; 8 markers; 1 count chip.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](invoke-tool-asserts-locked-version.drawio.png) draws from the source of the `Catzc.Tooling.Core` module.
The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every tool wrapper of cats, `Invoke-<Tool>`, calls `Assert-Tool` before it calls `Invoke-Executable`, so no tool runs unless its installed
version matches the version locked in `tools.yml`. `Assert-Tool` takes one of two branches. A tool whose entry declares candidate paths is
located and versioned by the probe, `Resolve-ToolExecutable`. Every other tool is checked on `PATH` and then by `Assert-ToolVersion`, which
reads the version once per session through `Get-ToolVersion`. `Test-Tool` answers the same question as a boolean and takes the same two
branches.

## Walkthrough

1. **`Invoke-<Tool>`** is the set of tool wrappers, one per wrapped tool. The count chip says ten wrappers exist, and every one calls
   `Assert-Tool` before it calls `Invoke-Executable`. A `-DryRun` call skips the assert, because nothing runs.
2. **`Assert-Tool`** looks the tool up and branches on whether its entry declares candidate paths (ADR-AUTO-DEPS#3).
3. **`Resolve-ToolExecutable`** is the probe in `Catzc.Base.Execution`. It reads the tool's entry once and returns where the tool is and
   whether its version is accepted (ADR-CONF-LOADING#6). Of the ten wrapped tools, only `go` takes this branch.
4. **`Assert-ToolVersion`** runs once `Assert-Command` has found the command on `PATH`. It throws on a version mismatch and remembers a pass
   for the rest of the session (ADR-PWSH-CACHE#4).
5. **`Get-ToolVersion`** runs the entry's `version_command` and extracts the version with its `version_pattern`.
6. **`tools.yml`** locks each tool's `version`, its `version_command` and its candidate paths. Every box above reads it through its entry;
   no single call site reads the file, so no edge enters it.
7. **`Invoke-Executable`** runs the tool for the wrapper, and runs the version command for `Get-ToolVersion`.
8. **`Test-Tool`** is the boolean twin of `Assert-Tool`: the probe for an entry with candidate paths, otherwise `Get-ToolVersion` directly.

## Reading path

Start at the named set on the left, outside the band. Its edge enters `Assert-Tool` in the TOOLING CORE band. Follow the top row right
through `Assert-ToolVersion` to `Get-ToolVersion`, then down into the `Catzc.Base.Execution` frame to `Invoke-Executable`. From
`Assert-Tool`, a second edge drops straight down to `Resolve-ToolExecutable` at the left of the frame. `Test-Tool`, in the middle of the
band, has two edges: one left and down to `Resolve-ToolExecutable`, one right and up to `Get-ToolVersion`. The named set's second edge runs
down its left side, under the frame, and up into `Invoke-Executable`. `tools.yml` sits alone in the middle of the frame.

## Glyphs

| Glyph                    | Kind           | Band or frame        | Marker |
| ------------------------ | -------------- | -------------------- | ------ |
| `Invoke-<Tool>`          | named set      | none (left)          | 1      |
| `Assert-Tool`            | code unit      | TOOLING CORE         | 2      |
| `Resolve-ToolExecutable` | code unit      | Catzc.Base.Execution | 3      |
| `Assert-ToolVersion`     | private helper | TOOLING CORE         | 4      |
| `Get-ToolVersion`        | code unit      | TOOLING CORE         | 5      |
| `tools.yml`              | file           | Catzc.Base.Execution | 6      |
| `Invoke-Executable`      | code unit      | Catzc.Base.Execution | 7      |
| `Test-Tool`              | code unit      | TOOLING CORE         | 8      |

The band labelled TOOLING CORE fills the top of the drawing area. The `Catzc.Base.Execution` catzc module frame, an outline with no fill and
its name at the top-left, runs the full width below it. A count chip reading `10` sits on the bottom-right corner of the named set, away
from its marker. The private helper has a darker fill and a smaller name than the code units.

## Edges

Every edge is a flow edge meaning "calls". Each is backed by a call site in the source.

| From                 | To                       | Call site                                                      |
| -------------------- | ------------------------ | -------------------------------------------------------------- |
| `Invoke-<Tool>`      | `Assert-Tool`            | each wrapper, e.g. `Invoke-Terraform.ps1`, `Invoke-Dotnet.ps1` |
| `Invoke-<Tool>`      | `Invoke-Executable`      | each wrapper, after the assert                                 |
| `Assert-Tool`        | `Resolve-ToolExecutable` | `Assert-Tool.ps1`, when the entry declares candidate paths     |
| `Assert-Tool`        | `Assert-ToolVersion`     | `Assert-Tool.ps1`, otherwise                                   |
| `Assert-ToolVersion` | `Get-ToolVersion`        | `private/Assert-ToolVersion.ps1`                               |
| `Get-ToolVersion`    | `Invoke-Executable`      | `Get-ToolVersion.ps1`                                          |
| `Test-Tool`          | `Resolve-ToolExecutable` | `Test-Tool.ps1`, when the entry declares candidate paths       |
| `Test-Tool`          | `Get-ToolVersion`        | `Test-Tool.ps1`, otherwise                                     |

The two edges that leave `Test-Tool` and the long edge from the named set to `Invoke-Executable` are drawn as straight segments with
right-angle bends. No edge enters `tools.yml`.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- private helper
- named set
- file
- catzc module
- flow: calls
- marker: a Walkthrough step
- count chip: `Invoke-<Tool>` wrappers

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-DRYRUN#2, ADR-PWSH-CACHE#4 and ADR-CONF-LOADING#6:
the rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

They don't differ on what this slide draws: ADR-AUTO-DEPS#3 names both branches of `Assert-Tool`. The rule for which installed versions pass
(the locked version, and outside a pipeline the optional `devbox_version`) is written out three times in the code, in `Assert-ToolVersion`,
`Test-Tool` and `Resolve-ToolExecutable`; the ADR does not say where it lives.
