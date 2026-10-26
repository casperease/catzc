---
name: test-speed
description: >
  Make the test suite faster one measured file at a time by the ADR-AUTO-TEST speed rules, without losing a test or an assertion; the
  timeouts.yml limits are roofs, never raised; input is a test run, or a named slow test file.
user-invocable: false
allowed-tools: Bash, Read, Grep, Edit, Write
paths: pwsh/**/tests/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# test-speed

1. Quote the roofs from `pwsh/Base.Timeouts/configs/timeouts.yml` (`tests.run_seconds`, `tests.level_ms`, `limits.devbox.bash.background`);
   measure from the latest `out/test-automation/<run>/` (`results-shard-*.xml`, `rows-shard-*.json`): per-file, per-module and per-shard
   seconds, the slowest 25 tests with tier, every test over its tier's `level_ms`; never start a full `Test-Automation` run.
2. Take the costliest file not yet worked on, skipping a peer-dirty one; run it alone twice with `Invoke-TestFile` through catzc-gate and
   keep the second timing; time `BeforeAll`, `BeforeEach` and each `It` with a Stopwatch in a scratch copy under `out/`, count process
   launches, imports and per-test cache rebuilds, find `Get-ChildItem`, `Copy-Item -Recurse`, `New-Item`, `Set-Content` on hot paths and
   repository-wide scans where one file would do; name the cause in one sentence with its evidence (ADR-AUTO-TEST-MEASUREFIRST).
3. Fix that one cause by its rule: set-up repeated per test builds once in `BeforeAll` (ADR-AUTO-TEST-SETUPONCE); repeated imports or
   spawns of one tree become one import asserted in separate `It` blocks (ADR-AUTO-TEST-ONEIMPORTPERCASE); filesystem cmdlets on a hot path
   become `[System.IO]` or `Copy-Directory` (ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS); L2/L3 tests re-proving one wiring keep one integration
   test and move per-case assertions into L0 (ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS, ADR-AUTO-TEST-FEWINTEGRATIONTESTS).
4. Prove nothing was lost: same test names (a moved assertion listed with its new home), same or more `Should` assertions, all passing, the
   new timing from two runs, one tier and one category tag per test (ADR-AUTO-TEST-TWOMANDATORYTAGS), `Test-ScriptAnalyzer -Path <changed>
   -PassThru` at 0; never remove, weaken, skip or re-tier a test, mock away an L2/L3 integration, raise a roof or add an exemption.
5. Repeat from step 2 until the costliest file has no cause fixable without changing what it proves; write
   `out/test-speed-<yyyy-MM-dd>.md`: the table, per file the cause, rule, before and after, files left over their roof with the
   decision each needs, the next three files by cost.
