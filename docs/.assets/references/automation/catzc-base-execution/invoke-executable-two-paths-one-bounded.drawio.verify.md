---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
    folder: docs/.assets/references/automation/catzc-base-execution
    name: invoke-executable-two-paths-one-bounded-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "9b66ab21863d"
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-FAILFAST#7
      - ADR-PWSH-ASSERT#1
---

# out/diagrams/wave-9/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md

`Verification: Invoke-Executable: only the streamed path is time-bounded (source lens, Catzc.Base.Execution)`

Every line below was re-read on 2026-10-15 after the comment export. The scout's numbers had all moved (for example the `-Direct` switch
from `Invoke-Executable.ps1:58` to `:57-58`, the kill from `CliRunner.cs:189-196` to `:170-176`, `Invoke-Expression` from
`Invoke-ExecutableDirect.ps1:55-57` to `:49`), so none is reused. Paths are relative to `automation/Catzc.Base.Execution/` unless they start
with `automation/`, `docs/` or `.claude/`.

## Boxes

| #   | Claim (box)                                                                                      | Source (`file:line`)                                                                         | Status    |
| --- | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- | --------- |
| B1  | `Invoke-Executable` is a public function (code unit)                                             | `Invoke-Executable.ps1:49`, at the module root                                               | confirmed |
| B2  | `Get-TimeoutSeconds` is a public function of `Catzc.Base.Timeouts` (frame)                       | `automation/Catzc.Base.Timeouts/Get-TimeoutSeconds.ps1:36`                                   | confirmed |
| B3  | `timeouts.yml` is a config of `Catzc.Base.Timeouts`, read by `Get-TimeoutSeconds`                | `automation/Catzc.Base.Timeouts/configs/timeouts.yml:7-29`; `Get-TimeoutSeconds.ps1:61,63`   | confirmed |
| B4  | `Invoke-ExecutableStreamed` is private                                                           | `private/Invoke-ExecutableStreamed.ps1`                                                      | confirmed |
| B5  | `CliRunner` is a C# type under `types/`                                                          | `types/CliRunner.cs:33,54`                                                                   | confirmed |
| B6  | Failure `Kill · TimeoutException`: past the limit the process tree is killed and the call throws | `types/CliRunner.cs:170-179` (`Kill(entireProcessTree: true)`, `throw new TimeoutException`) | confirmed |
| B7  | `Invoke-ExecutableDirect` is private                                                             | `private/Invoke-ExecutableDirect.ps1:21`                                                     | confirmed |
| B8  | `Invoke-Expression` runs the command with no time limit                                          | `private/Invoke-ExecutableDirect.ps1:45-54` (no timeout parameter, no wait bound)            | confirmed |

## Edges (flow: runs next, in code order)

| #   | Edge                                                              | Source (`file:line`)                                                            | Status    |
| --- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------- | --------- |
| E1  | `Invoke-Executable` → `Get-TimeoutSeconds` (fork, not `-Direct`)  | `Invoke-Executable.ps1:103,106-108` (only when `-TimeoutSeconds` is not passed) | confirmed |
| E2  | `Get-TimeoutSeconds` → `Invoke-ExecutableStreamed`                | `Invoke-Executable.ps1:108,110`                                                 | confirmed |
| E3  | `Invoke-ExecutableStreamed` → `CliRunner`                         | `private/Invoke-ExecutableStreamed.ps1:59,62` (`RunBytes` / `Run`)              | confirmed |
| E4  | `CliRunner` → `Kill · TimeoutException` (failure path)            | `types/CliRunner.cs:83,235` (`Supervise` calls) → `:170-176`                    | confirmed |
| E5  | `Invoke-Executable` → `Invoke-ExecutableDirect` (fork, `-Direct`) | `Invoke-Executable.ps1:103-104`                                                 | confirmed |
| E6  | `Invoke-ExecutableDirect` → `Invoke-Expression`                   | `private/Invoke-ExecutableDirect.ps1:49`                                        | confirmed |

## Bands, frame and sidebar

| #   | Claim                                                                                                  | Source (`file:line`)                                                                         | Status                       |
| --- | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- | ---------------------------- |
| C1  | The two bands are the two parameter sets: `Stream` (default) and `Direct`                              | `Invoke-Executable.ps1:52,57-58,60-68`                                                       | confirmed                    |
| C2  | `-TimeoutSeconds` belongs to the `Stream` set only, so `-Direct` cannot take a limit                   | `Invoke-Executable.ps1:66-68`                                                                | confirmed                    |
| C3  | The executable's limit is its `executables:` entry, else the environment's pwsh limit                  | `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs:278-283`                             | confirmed                    |
| C4  | `CliRunner` refuses a non-positive limit: every streamed run has one                                   | `types/CliRunner.cs:35-38,56-59`                                                             | confirmed                    |
| C5  | The code's own comment calls `-Direct` unbounded by design ("a person at the prompt is its safeguard") | `docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md:37-40` (comment:1) | confirmed                    |
| C6  | No in-tree caller passes `-Direct` (only the help example)                                             | grep `-Direct` over `automation/**/*.ps1` outside tests: `Invoke-Executable.ps1:36` only     | confirmed                    |
| C7  | Supports: ADR-AUTO-DRYRUN#2, ADR-AUTO-TEST and ADR-PWSH-ASSERT#1, cited by the drawn code              | `Invoke-Executable.ps1:47,77`; `Get-TimeoutSeconds.ps1:6`; `timeouts.yml:2`                  | confirmed                    |
| C8  | ADR-AUTO-FAILFAST#7 says `Invoke-Executable` kills a child process tree at its executable's limit      | `docs/adr/automation/fail-fast-with-asserts.md:59`; `.claude/CLAUDE.md:110`                  | contradicted (for `-Direct`) |

Counts: 22 claims, 21 confirmed, 1 contradicted, 0 ADR-only.

## Corrections

- The brief's tripwire check (`CATZC_BLOCK_REAL_PROCESS`, `Invoke-Executable.ps1:79-85`) is cut: it guards unit tests on both paths alike,
  so it says nothing about the bound, and keeping it pushed the legend past eight entries.
- The brief named the failure `Kill(entireProcessTree)`; the slide names it `Kill · TimeoutException`, the kill and the throw together.
- Every scout line number had moved; all the numbers above are new.

## Drift

- ADR-AUTO-FAILFAST#7 (`docs/adr/automation/fail-fast-with-asserts.md:59`) and `.claude/CLAUDE.md:110` say `Invoke-Executable` kills a child
  process tree at its executable's limit. The code does so only on the default `Stream` path; `-Direct` runs `Invoke-Expression` with no
  bound and cannot take `-TimeoutSeconds`. The code's comment says this is deliberate (interactive mode), so the ADR sentence is the side
  that is out of step; ADR-AUTO-FAILFAST#7 also says "Bound every wait", which `-Direct` does not.
- The drawn code cites no ADR-AUTO-FAILFAST rule, although the streamed path implements ADR-AUTO-FAILFAST#7. A citation in
  `Invoke-Executable.ps1` or `CliRunner.cs` would make the Supports chips name it.
- Naming hazard: `CliRunner`'s private method `RunDirect` (`types/CliRunner.cs:100`) is the bounded streamed run, not the `-Direct` path.

## Cut

The tripwire (`:79-85`), `Assert-PathExist` (`:87`), `Write-Message` (`:91`), the `-DryRun` early returns, `Reset-LastExitCode` and
`Assert-LastExitCodeWasZero` on both paths, `CliRunner.ExecutableName` (`:108`, it names the executable for `Get-TimeoutSeconds`), the drain
limit and its `IOException` (`types/CliRunner.cs:163,182-189`), `CliResult`, and `Get-RunEnvironment` / `Get-Config` inside
`Get-TimeoutSeconds`.
