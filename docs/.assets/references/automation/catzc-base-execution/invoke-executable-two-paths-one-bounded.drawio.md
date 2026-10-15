---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
    kind: asset-description
    body_sha: "4277d8fc37cc"
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-FAILFAST#7
      - ADR-PWSH-ASSERT#1
---

# Invoke-Executable: only the streamed path is time-bounded: the diagram described

```text
A 1588 x 552 diagram, read left to right, forking into two bands, top and bottom.
Glyphs: 2 code units, 1 code unit in a catzc module frame, 2 private helpers, 1 C# type, 1 file, 1 failure;
6 flow edges, 1 failure path; 7 markers; 1 "no time limit" chip.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](invoke-executable-two-paths-one-bounded.drawio.png) draws from the source of the `Catzc.Base.Execution`
module. The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every external command that cats runs goes through `Invoke-Executable`, which takes one of two paths by parameter set. The default `Stream`
path looks up the executable's time limit, hands the command to the `CliRunner` type, and kills the whole process tree with a
`TimeoutException` when the limit runs out. The `-Direct` path runs the command through `Invoke-Expression` so that colours, spinners and
progress bars reach the console, and it has no time limit at all: the `Direct` parameter set cannot even take `-TimeoutSeconds`. No caller
in the tree passes `-Direct` today.

## Walkthrough

1. **`Invoke-Executable`** is the public entry point. It logs the command, then forks on `-Direct`: without it the call takes the `Stream`
   path (top band), with it the `Direct` path (bottom band).
2. **`Get-TimeoutSeconds`**, from `Catzc.Base.Timeouts`, returns the executable's limit: its entry under `executables:` in `timeouts.yml`,
   or the run environment's pwsh limit when it has none. A caller can pass `-TimeoutSeconds` to set the limit for one call instead.
3. **`Invoke-ExecutableStreamed`** passes the command and its limit to `CliRunner`, as text or, with `-AsBytes`, as raw bytes, and turns the
   exit code into `$LASTEXITCODE`.
4. **`CliRunner`** starts the process with its output redirected and waits for it within the limit. It refuses to run without a positive
   limit.
5. **`Kill · TimeoutException`**: when the process outlives its limit, `CliRunner` kills it with its whole process tree and throws a
   `TimeoutException` that names the limit and where to tune it (ADR-AUTO-FAILFAST#7).
6. **`Invoke-ExecutableDirect`** runs the command in the working directory with its output going straight to the console, then asserts the
   exit code.
7. **`Invoke-Expression`** runs the command with no time limit, which the chip after it states. The bottom band has no failure glyph on
   purpose: nothing stops a `-Direct` call that hangs. The code treats this as intended, since `-Direct` is the interactive mode and a
   person at the prompt is its safeguard.

## Reading path

Start at `Invoke-Executable` on the left, outside the bands. Its edge runs right to a junction left of the bands and splits: up into the
STREAM band and down into the DIRECT band. In the STREAM band, follow the flow right from `Get-TimeoutSeconds` (inside the
`Catzc.Base.Timeouts` frame) through `Invoke-ExecutableStreamed` and `CliRunner` to the red failure glyph at the band's right end. In the
DIRECT band, follow the flow right from `Invoke-ExecutableDirect` to `Invoke-Expression`, which is followed by a pill chip reading
`no time limit` directly under the failure glyph above.

## Glyphs

| Glyph                       | Kind                           | Band   | Marker |
| --------------------------- | ------------------------------ | ------ | ------ |
| `Invoke-Executable`         | code unit                      | none   | 1      |
| `Get-TimeoutSeconds`        | code unit, in the catzc module | STREAM | 2      |
| `timeouts.yml`              | file, in the catzc module      | STREAM | —      |
| `Invoke-ExecutableStreamed` | private helper                 | STREAM | 3      |
| `CliRunner`                 | C# type                        | STREAM | 4      |
| `Kill · TimeoutException`   | failure                        | STREAM | 5      |
| `Invoke-ExecutableDirect`   | private helper                 | DIRECT | 6      |
| `Invoke-Expression`         | code unit                      | DIRECT | 7      |
| `no time limit`             | chip (no edge)                 | DIRECT | —      |

The catzc module frame `Catzc.Base.Timeouts` sits at the left of the STREAM band and holds `Get-TimeoutSeconds` above `timeouts.yml`.
`timeouts.yml` has no edge: the frame places it as the config `Get-TimeoutSeconds` reads. The two private helpers stand in one column, one
per band, with a darker fill than the code units.

## Edges

Every flow edge means "runs next, in code order". Each is backed by a call site in the source.

| From                        | To                          | Kind         | Call site                                      |
| --------------------------- | --------------------------- | ------------ | ---------------------------------------------- |
| `Invoke-Executable`         | `Get-TimeoutSeconds`        | flow         | `Invoke-Executable.ps1`, when `-Direct` is off |
| `Get-TimeoutSeconds`        | `Invoke-ExecutableStreamed` | flow         | `Invoke-Executable.ps1`                        |
| `Invoke-ExecutableStreamed` | `CliRunner`                 | flow         | `private/Invoke-ExecutableStreamed.ps1`        |
| `CliRunner`                 | `Kill · TimeoutException`   | failure path | `types/CliRunner.cs`                           |
| `Invoke-Executable`         | `Invoke-ExecutableDirect`   | flow         | `Invoke-Executable.ps1`, when `-Direct` is on  |
| `Invoke-ExecutableDirect`   | `Invoke-Expression`         | flow         | `private/Invoke-ExecutableDirect.ps1`          |

The two edges out of `Invoke-Executable` share one line to the junction left of the bands, then split up and down.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- private helper
- C# type
- catzc module
- file
- failure, and its failure path
- flow: runs next (code order)
- marker: a Walkthrough step

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-DRYRUN#2, ADR-AUTO-TEST and ADR-PWSH-ASSERT#1: the
rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

ADR-AUTO-FAILFAST#7 states that `Invoke-Executable` kills a child process tree at its executable's limit. The code does that only on the
default `Stream` path. The `-Direct` path runs `Invoke-Expression` with no limit and cannot be given one, by the code's own design.
