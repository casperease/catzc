---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
    folder: docs/.assets/references/automation/catzc-base-qualitygates
    name: test-automation-one-run-pipeline-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "3d8cf505cd81"
    adrs:
      - ADR-AUTO-TEST#{13,26,30}
      - ADR-REPO-PROTGLOB#9
    links:
      - docs/.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.png
---

# One discovery feeds three phases; finally stamps run.json: the diagram described

```text
A 1588 x 672 diagram, read left to right through three bands, top to bottom.
Glyphs: 2 code units, 7 private helpers, 1 gate, 3 named sets, 1 file; 8 flow edges; 8 markers; 1 count chip.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](test-automation-one-run-pipeline.drawio.png) draws from the source of the `Catzc.Base.QualityGates`
module. The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every test run of cats goes through one private function, `Invoke-TestRun`, whichever public entry point starts it. It discovers the tests
once and checks their tags before it creates a run directory. Inside a `try` it splits the files into three phases, drops the modules that
are already protected, runs the workers and derives one verdict. The `finally` stamps `run.json` on every exit from that `try`, so the
record of a run is truthful whether the run passes, fails or crashes.

## Walkthrough

1. **`Invoke-TestRun`** is the shared core of `Test-Automation` and `Test-CatzcBuild`, the two kinds of test run (ADR-AUTO-TEST#30). Each
   entry point passes its own name as `-EntryPoint`.
2. **`Get-TestDiscovery`** runs one discovery-only pass. The count chip says it feeds four later steps: the tag check, the file selection,
   the phase split and the protection decision. No step discovers the tests again.
3. **`Assert-TestTagGate`** enforces the two mandatory tag axes on every test, whatever the level (ADR-AUTO-TEST#13). It runs before the run
   directory exists, so a tag failure stops the run without writing `run.json`.
4. **`Split-TestAutomationFiles`** cuts the selected files into the three phases, `Parallel`, `Greedy` and `Serial`, which run in that order
   (ADR-AUTO-TEST#26). `Select-TestRunFiles` narrows the files just before this step; it is cut from the drawing.
5. **`Select-ProtectedTestFile`** drops the test files of every module whose composite identity is unchanged since its last green run in
   this session (ADR-REPO-PROTGLOB#9). When every module in scope is protected, nothing runs.
6. **`Invoke-TestAutomationWorkers`** shards the files, runs the parallel pool and then the greedy and serial phases, and collects the
   result rows.
7. **`Get-TestAutomationVerdict`** derives the verdict and its one-line reason once. The closing banner and the failure throw both use it.
8. **`run.json`** is stamped `running` at the start of the `try`, and the `finally` stamps its terminal state: `passed`, `failed`, or
   `crashed` when the run never set one. A run whose process dies before that stamp is marked `abandoned` by the next run.

## Reading path

Start at the two code units on the left, outside the bands. Their edges join and enter `Invoke-TestRun` in the BEFORE TRY band. Follow the
flow right through `Get-TestDiscovery` to the `Assert-TestTagGate` gate. From the gate, one edge drops out of the band and runs left to
`Split-TestAutomationFiles` at the start of the TRY band. Follow the TRY band right to `Get-TestAutomationVerdict`. The FINALLY band below
holds the `run.json` file alone.

## Glyphs

| Glyph                          | Kind           | Band        | Marker |
| ------------------------------ | -------------- | ----------- | ------ |
| `Test-Automation`              | code unit      | none (left) | —      |
| `Test-CatzcBuild`              | code unit      | none (left) | —      |
| `Invoke-TestRun`               | private helper | BEFORE TRY  | 1      |
| `Get-TestDiscovery`            | private helper | BEFORE TRY  | 2      |
| `Assert-TestTagGate`           | gate           | BEFORE TRY  | 3      |
| `Split-TestAutomationFiles`    | private helper | TRY         | 4      |
| `Parallel`, `Greedy`, `Serial` | named set (×3) | TRY         | —      |
| `Select-ProtectedTestFile`     | private helper | TRY         | 5      |
| `Invoke-TestAutomationWorkers` | private helper | TRY         | 6      |
| `Get-TestAutomationVerdict`    | private helper | TRY         | 7      |
| `run.json`                     | file           | FINALLY     | 8      |

The three named sets sit in a row directly under `Split-TestAutomationFiles`, with no edge. A count chip reading `4` sits on the
bottom-right corner of `Get-TestDiscovery`, away from its marker. Private helpers have a darker fill than the two code units.

## Edges

Every edge is a flow edge meaning "runs next, in code order". Each is backed by a call site in the module's source.

| From                           | To                             | Call site                                                   |
| ------------------------------ | ------------------------------ | ----------------------------------------------------------- |
| `Test-Automation`              | `Invoke-TestRun`               | `Test-Automation.ps1`                                       |
| `Test-CatzcBuild`              | `Invoke-TestRun`               | `Test-CatzcBuild.ps1`                                       |
| `Invoke-TestRun`               | `Get-TestDiscovery`            | `private/Invoke-TestRun.ps1`                                |
| `Get-TestDiscovery`            | `Assert-TestTagGate`           | `private/Invoke-TestRun.ps1`                                |
| `Assert-TestTagGate`           | `Split-TestAutomationFiles`    | `private/Invoke-TestRun.ps1`, across the start of the `try` |
| `Split-TestAutomationFiles`    | `Select-ProtectedTestFile`     | `private/Invoke-TestRun.ps1`                                |
| `Select-ProtectedTestFile`     | `Invoke-TestAutomationWorkers` | `private/Invoke-TestRun.ps1`                                |
| `Invoke-TestAutomationWorkers` | `Get-TestAutomationVerdict`    | `private/Invoke-TestRun.ps1`                                |

The two entry edges meet at a junction left of the BEFORE TRY band and enter `Invoke-TestRun` as one arrow. No edge enters `run.json`. The
FINALLY band places it.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- private helper
- gate
- file
- named set
- flow: runs next (code order)
- marker: a Walkthrough step
- count chip: steps fed by the one discovery

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-TEST#13, #26 and #30, and ADR-REPO-PROTGLOB#9: the
rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

They don't differ on what this slide draws. The phase order, the `run.json` stamping and the `abandoned` rule match ADR-AUTO-TEST.
