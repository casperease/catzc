# Run tests and checks

`Test-Automation` is the single entry point for the test suite. It discovers every `tests/*.Tests.ps1` file across all modules, runs them
through Pester, and writes a timestamped report under `out/`. Linting, spell-check, and formatting are separate one-call functions.

## Run the tests

```powershell
. ./importer.ps1
Test-Automation                       # L0 + L1 + L2 — the default (L2 self-skips a tool that is absent)
Test-Automation -Level 1              # unit-only — skip L2 for a faster pass
Test-Automation -Output Detailed      # per-test output instead of the summary
```

Useful parameters (`Get-Help Test-Automation -Full` for the rest):

| Parameter              | Effect                                                                                             |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| `-Level` / `-MaxLevel` | Highest tier to run. `2` = L0+L1+L2 (default), `1` = L0+L1 only, `3` = all                         |
| `-MinLevel`            | Lowest tier. `-MinLevel 2 -MaxLevel 2` runs **only** L2                                            |
| `-Modules`             | Restrict to one or more modules: `-Modules Catzc.Azure, Catzc.Azure.Cli`                           |
| `-Category`            | `Logic` (hermetic, mocks/fixtures), `Integrity` (real configs/templates/repo), or `Both` (default) |
| `-Output`              | Pester verbosity: `Normal` (default), `Detailed`, `Diagnostic`                                     |
| `-OutputFolder`        | Base folder for the report (defaults under `out/test-automation/`)                                 |
| `-PassThru`            | Return the Pester result object as well as writing the report                                      |

## The tiers

Tests are tagged by **what they integrate with**, and every test carries exactly one tier tag plus one category tag (`logic`/`integrity`). A
run fails fast if any test is missing — or ambiguous on — either tag.

| Tier | Scope                                           | Time budget |
| ---- | ----------------------------------------------- | ----------- |
| L0   | Pure logic, no I/O                              | < 400 ms    |
| L1   | Unit tests, may touch disk                      | < 2 s       |
| L2   | CLI-tool integration (spawns `az`, `dotnet`, …) | < 120 s     |
| L3   | Cloud-API integration — opt-in, self-skips      | —           |

L2/L3 tests **self-skip** when their tool or cloud access is missing, so the default devbox run stays green without `az` configured. See
[test-automation](../../../adr/automation/test-automation.md) for the logic-vs-integrity split and the isolation idioms, and
[retry-as-last-resort](../../../adr/automation/retry-as-last-resort.md) for why tests never retry.

## The report

Every run writes to `out/test-automation/<yyyyMMdd-HHmmss>/`, and `out/test-automation/latest.txt` names the newest run:

- `results.xml` — Pester NUnit output (names, durations, failures)
- `summary.md` — counts, failures with `file:line`, slowest tests, over-budget timings
- `tests.csv` — one row per test, for sorting by duration

## Linters, spelling, and formatting

These are independent of the Pester suite:

```powershell
Format-Automation          # auto-format every PowerShell file (PSScriptAnalyzer + .editorconfig)
Format-Markdown            # format Markdown to the house style (alias: Invoke-MarkdownPrettier)
Test-Markdownlint          # lint Markdown        -> out/test-markdownlint/
Test-Spelling              # cspell vs cspell.yml  -> out/test-spelling/
Format-Spelling            # register flagged words into cspell.yml (-DryRun to preview)
```

`Format-Spelling` is the auto-fix counterpart to `Test-Spelling`: it scans the same content and adds every word cspell flags to the
top-level `words:` list in `cspell.yml`, so the dictionary diff is the review surface. Use it to accept new content words; an invented
identifier abbreviation is spelled out instead (see [spell-out-names](../../../adr/automation/powershell/spell-out-names.md)).

PSScriptAnalyzer itself (style, approved verbs, the custom rules under `automation/.scriptanalyzer/`) runs as part of the **L2** suite via
the analyzer test — so `Test-Automation -Level 2` is what catches a formatting or convention violation before CI does.

## What CI runs

CI runs the same functions you do — there is no separate CI test script. It runs `Test-Automation` at Level 2 across Windows, Linux, and
macOS. Because everything is vendored and `$ErrorActionPreference = 'Stop'`, a failure surfaces as a non-zero exit code with the failing
`file:line` in `summary.md`.
