---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/.assets/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.verify.md
    folder: docs/references/.assets/automation/catzc-base-qualitygates
    name: test-automation-one-run-pipeline-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-TEST#{13,26}
      - ADR-REPO-PROTGLOB#9
---

# out/diagrams/dark-sample/test-automation-one-run-pipeline.drawio.verify.md

`Verification: One discovery feeds three phases; finally stamps run.json (source lens, Catzc.Base.QualityGates)`

Every line below was re-read on 2026-10-15 after the comment export. The wave-9 scout's line numbers had all moved (for example the
Invoke-TestRun call moved from `Test-Automation.ps1:187` to `:148`), so none of the scout's numbers is reused. `condense-comments` may move
them again, so re-grep before landing. Paths are relative to `automation/Catzc.Base.QualityGates/` unless they start with `automation/` or
`docs/`.

## Boxes

| #   | Claim (box)                                                                 | Source (`file:line`)                                                                                  | Status    |
| --- | --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------- |
| B1  | `Test-Automation` is a public function (code unit)                          | `Test-Automation.ps1` at the module root                                                              | confirmed |
| B2  | `Test-CatzcBuild` is a public function (code unit)                          | `Test-CatzcBuild.ps1` at the module root                                                              | confirmed |
| B3  | `Invoke-TestRun` is private, the shared core of both entries                | `private/Invoke-TestRun.ps1:3`                                                                        | confirmed |
| B4  | `Get-TestDiscovery` is private                                              | `private/Get-TestDiscovery.ps1`                                                                       | confirmed |
| B5  | `Assert-TestTagGate` is a gate: it throws on a missing tag axis             | `private/Invoke-TestRun.ps1:115-116`; cites ADR-AUTO-TEST#13 at `private/Assert-TestTagGate.ps1:6`    | confirmed |
| B6  | `Split-TestAutomationFiles` is private and returns Parallel, Greedy, Serial | `private/Split-TestAutomationFiles.ps1:14,61-63`                                                      | confirmed |
| B7  | The three phase chips run in the order parallel, greedy, serial             | `docs/adr/automation/test-automation.md:188-190` (ADR-AUTO-TEST#26); `private/Invoke-TestRun.ps1:209` | confirmed |
| B8  | `Select-ProtectedTestFile` drops the files of protected units               | `private/Select-ProtectedTestFile.ps1:3-5,80-86`                                                      | confirmed |
| B9  | `Invoke-TestAutomationWorkers` is private and runs the shards               | `private/Invoke-TestRun.ps1:209-226`; `private/Invoke-TestAutomationWorkers.ps1`                      | confirmed |
| B10 | `Get-TestAutomationVerdict` is private and derives the verdict once         | `private/Invoke-TestRun.ps1:276-281`                                                                  | confirmed |
| B11 | `run.json` is the file `Write-TestRunManifest` writes                       | `private/Write-TestRunManifest.ps1:3,26`                                                              | confirmed |
| B12 | Count chip `4`: the one discovery feeds four steps                          | `private/Invoke-TestRun.ps1:116,170,179,189` (`-Discovery $discovery`)                                | confirmed |

## Edges (flow: runs next, in code order)

| #   | Edge                                                                  | Source (`file:line`)                                                                                                           | Status    |
| --- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------- |
| E1  | `Test-Automation` → `Invoke-TestRun`                                  | `Test-Automation.ps1:148`                                                                                                      | confirmed |
| E2  | `Test-CatzcBuild` → `Invoke-TestRun`                                  | `Test-CatzcBuild.ps1:102`                                                                                                      | confirmed |
| E3  | `Invoke-TestRun` → `Get-TestDiscovery`                                | `private/Invoke-TestRun.ps1:112` (after `Get-TestAutomationTestPaths` at :100, cut)                                            | confirmed |
| E4  | `Get-TestDiscovery` → `Assert-TestTagGate`                            | `private/Invoke-TestRun.ps1:112,116`                                                                                           | confirmed |
| E5  | `Assert-TestTagGate` → `Split-TestAutomationFiles` (crosses into TRY) | `private/Invoke-TestRun.ps1:116,141,179` (the `running` stamp at :156 and `Select-TestRunFiles` at :170 sit between them, cut) | confirmed |
| E6  | `Split-TestAutomationFiles` → `Select-ProtectedTestFile`              | `private/Invoke-TestRun.ps1:179,188`                                                                                           | confirmed |
| E7  | `Select-ProtectedTestFile` → `Invoke-TestAutomationWorkers`           | `private/Invoke-TestRun.ps1:188,222`; skipped when nothing is left (:211-219)                                                  | confirmed |
| E8  | `Invoke-TestAutomationWorkers` → `Get-TestAutomationVerdict`          | `private/Invoke-TestRun.ps1:222,278`                                                                                           | confirmed |

## Bands and markers

| #   | Claim                                                                                         | Source (`file:line`)                                                                                             | Status    |
| --- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------- |
| C1  | Discovery and the tag check run BEFORE TRY: a throw there leaves no run directory or run.json | `private/Invoke-TestRun.ps1:112,116` before `:126` (run directory) and `:141` (`try`)                            | confirmed |
| C2  | Split, protection, workers and verdict run inside TRY                                         | `private/Invoke-TestRun.ps1:141,179,188,222,278`                                                                 | confirmed |
| C3  | run.json is stamped `running` at the start of TRY                                             | `private/Invoke-TestRun.ps1:154-157`                                                                             | confirmed |
| C4  | FINALLY stamps the terminal run.json on every exit from TRY (`crashed` unless set)            | `private/Invoke-TestRun.ps1:132,314-320`                                                                         | confirmed |
| C5  | A run whose owner dies before the terminal stamp is marked `abandoned` by the next run        | `private/Invoke-TestRun.ps1:123-125`; `docs/adr/automation/test-automation.md:183`                               | confirmed |
| C6  | Supports: ADR-AUTO-TEST#13, #26, #30 and ADR-REPO-PROTGLOB#9, cited by the drawn code         | `private/Assert-TestTagGate.ps1:6`; `private/Invoke-TestRun.ps1:6,177`; `private/Select-ProtectedTestFile.ps1:3` | confirmed |

Counts: 26 claims, 26 confirmed, 0 contradicted, 0 ADR-only.

## Corrections

- The scout's finding said "a finally always stamps run.json". The code stamps run.json only once the run directory exists: discovery and
  the tag check run before the `try`, so their throws leave no run.json. The slide draws that boundary as the edge between the BEFORE TRY
  and TRY bands, and the title drops "always".
- Every scout line number had moved after the comment export. All the numbers above are new.

## Drift

None between this slide and the ADRs. ADR-AUTO-TEST#26 (phase order) and the run.json stamping and `abandoned` rule (test-automation.md:183)
match the code.

## Cut

`Get-TestAutomationTestPaths` (:100), `Set-AbandonedTestRun` and `New-TestAutomationRunDirectory` (:125-126), `Enter-TestRunLocation` /
`Exit-TestRunLocation` (:130, :323), `Select-TestRunFiles` (:170), the worker environment tripwire `CATZC_BLOCK_REAL_PROCESS` (:198-200),
`Protect-TestedModule` (:234), `Get-TestTimeLimits` / `Test-TestRunOverBudget` (:254-260, module Catzc.Base.Timeouts) and the reporting
writers. Each is one more box past the cap of 10; the description names the ones a reader needs.
