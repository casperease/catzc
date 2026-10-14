# docs/how-to/getting-started/automation/run-tests-and-checks.md

`Run tests and checks`

`Test-Automation` is the single entry point for all tests. It discovers every `tests/*.Tests.ps1` file across all modules, runs them through
Pester, and writes a timestamped report under `out/`. Linting, spell-check, and formatting are separate one-call functions.

## Check what you changed

```powershell
. ./importer.ps1
Test-Change -DryRun                   # what would run: the changed files, their test files, and their checks
Test-Change                           # run them; throws once listing every issue in the files you changed
(Test-Change -PassThru).Issues        # the same, returned instead of thrown
```

`Test-Change` is the check to run before handing work over. It reads the working tree's changes against `HEAD` (or the paths you pass), runs
the test files that cover them (a changed test file, the test file of a changed function, the test file of a changed C# type) through
`Invoke-TestFile`, and runs the quality gates each changed file's language names in `languages.yml` (`checks`). It reports only the issues
in the files you changed; the whole suite and the repository-wide gates stay `Test-Automation`'s job.

## Run the tests

```powershell
. ./importer.ps1
Test-Automation                       # L0 + L1 + L2 — the default (L2 self-skips a tool that is absent)
Test-Automation -Level 1              # unit-only — skip L2 for a faster pass
Test-Automation -Output Detailed      # per-test output instead of the summary
Test-Automation -Suite infrastructure # one test suite: the infrastructure globset's verify scope
```

A test suite is a named selection declared in `globs.yml`: a globset's `verify:` scope, its modules up to a top tier
([ADR-AUTO-TEST#37](../../../adr/automation/test-automation.md#rule-adr-auto-test37)). `Test-Automation -Suite infrastructure` runs the
`Catzc.Azure.Templates` tests up to L2, including the L2 tests that build every shipped template with `az bicep build` and check its
rendered parameters files against the compiled parameter model; without `az` those tests skip.

Useful parameters (`Get-Help Test-Automation -Full` for the rest):

| Parameter              | Effect                                                                                             |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| `-Level` / `-MaxLevel` | Highest tier to run. `2` = L0+L1+L2 (default), `1` = L0+L1 only, `3` = all                         |
| `-MinLevel`            | Lowest tier. `-MinLevel 2 -MaxLevel 2` runs **only** L2                                            |
| `-Modules`             | Restrict to one or more modules: `-Modules Catzc.Azure, Catzc.Azure.Cli`                           |
| `-Suite`               | Run one test suite, a globset's `verify:` scope from `globs.yml`: `-Suite infrastructure`          |
| `-Category`            | `Logic` (hermetic, mocks/fixtures), `Integrity` (real configs/templates/repo), or `Both` (default) |
| `-Output`              | Pester verbosity: `Normal` (default), `Detailed`, `Diagnostic`                                     |
| `-OutputFolder`        | Base folder for the report (defaults under `out/test-automation/`)                                 |
| `-PassThru`            | Return the Pester result object as well as writing the report                                      |

## The tiers

Tests are tagged by **what they integrate with**, and every test carries exactly one tier tag plus one category tag (`logic`/`integrity`). A
run fails fast if any test is missing — or ambiguous on — either tag.

| Tier | Scope                                           | Time budget |
| ---- | ----------------------------------------------- | ----------- |
| L0   | The core: pure logic, no I/O                    | < 400 ms    |
| L1   | The core: unit tests, may touch disk            | < 2 s       |
| L2   | Vertical, local-tool ring (`git`, `az`, …)      | < 120 s     |
| L3   | Vertical system tests, outside state; self-skip | —           |

L2/L3 tests **self-skip** when their tool or cloud access is missing, so the default devbox run stays green without `az` configured. See
[test-automation](../../../adr/automation/test-automation.md) for the logic-vs-integrity split and the isolation idioms, and
[retry-as-last-resort](../../../adr/automation/retry-as-last-resort.md) for why tests never retry.

## The report

Every run writes to `out/test-automation/<yyyyMMdd-HHmmss>/`, and `out/test-automation/latest.txt` names the newest run:

- `results-shard-<N>.xml` — Pester NUnit output per worker shard (names, durations, failures)
- `rows-shard-<N>.json` — each shard's per-test rows, the shape the merged reports are built from
- `summary.md` — counts, failures with `file:line`, slowest tests, over-budget timings (merged across shards)
- `tests.csv` — one row per test, for sorting by duration (merged across shards)
- `shard-<N>.ps1` — the generated worker runner scripts, kept for diagnosis
- `run.json` — the run's state: `running`, then `passed`, `failed`, or `crashed`, and where it ran (in place or a snapshot)

A failed run ends with every failure's message on the console: each failed test, and each test file that failed before its tests ran.
`Invoke-TestFile` writes the same folder shape under `out/test-file/`. To read a run's artifacts from a script, take `RunDirectory` from
`-PassThru`; never pick the newest folder by name or time, which can be another session's run when several work in the repository at once.

## Linters, spelling, and formatting

These run independently of `Test-Automation`:

```powershell
Format-Code                # format every tracked file with the engine languages.yml names for its language
Test-Markdownlint          # lint Markdown        -> out/test-markdownlint/
Test-Spelling              # cspell vs cspell.yml  -> out/test-spelling/
Export-SpellingTriage      # queue the flagged words for triage -> out/terminology-triage.yml (-DryRun to preview)
```

`Export-SpellingTriage` scans the same content as `Test-Spelling` and writes every flagged word to a triage queue under `out/`. A queued
word is still flagged: it is accepted only when someone adds it to the terminology registry (`terminology.yml`) with its meaning and
category, and an invented identifier abbreviation is spelled out instead (see
[spell-out-names](../../../adr/automation/spell-out-names.md)).

PSScriptAnalyzer itself (style, approved verbs, the custom rules under `automation/.scriptanalyzer/`) runs as part of the **L2** tests via
the analyzer test — so `Test-Automation -Level 2` is what catches a formatting or convention violation before CI does.

## Marker freshness and protected scans

Two globset-backed behaviors show up in quality-gate runs (see [durable-sha-globs](../../../adr/flow/durable-sha-globs.md) and
[protected-globs](../../../adr/automation/protected-globs.md)):

- A red **trigger globs** test means a pipeline's `trigger:`/`pr:` `paths:` filter has drifted from its globset's projection — regenerate it
  from `Get-GlobSetTrigger`. Run `Test-AdoPipelineTriggerGlob -PassThru` / `Test-GitHubWorkflowTriggerGlob -PassThru` to list one issue per
  drifted or missing pipeline without throwing.
- A **skipped** repository spelling/markdown scan (`protected_globset_unchanged_since_green_run`) means that scan already ran green against
  the identical file set this session — a local-only optimization, never active in CI. `Clear-GlobSetProtection` (or reloading the importer)
  forces a full rescan.
- A **"module(s) skipped (protected)"** line means those modules' composite identity — their own files, their declared dependencies, the
  loader/vendor/compiled-types infrastructure, and the test harness — is unchanged since their last green run this session, so their test
  files were dropped from the run. Same rules: session memory only, never in CI, and the protection key carries the run's level/category, so
  a `-Level 1` green never skips a `-Level 2` run. `Clear-GlobSetProtection` makes the next run execute all tests again.

## What CI runs

CI runs the same functions you do — there is no separate CI test script. It runs `Test-Automation` at Level 2 across Windows, Linux, and
macOS. Because everything is vendored and `$ErrorActionPreference = 'Stop'`, a failure surfaces as a non-zero exit code with the failing
`file:line` in `summary.md`.
