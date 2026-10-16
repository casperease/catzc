---
name: test-speed
description:
  Diagnose why one test file is slow and fix one cause by the ADR-AUTO-TEST speed rules without losing a test or an assertion; for
  test-optimization; input is the test file path and the roofs read from timeouts.yml.
user-invocable: false
allowed-tools: Bash, Read, Grep, Edit, Write
paths: automation/**/tests/**
metadata:
  catzc:
    immutable:
      with_body_sha: facfd87cd418
      repo_status: clean
      path: ".claude/skills/test-speed/SKILL.md"
      folder: skills/test-speed
      name: skill
      filetype: md
      kind: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    edges:
      cites:
        - ADR-AUTO-TEST#{13,19-22}
        - ADR-PWSH-PESTER#9
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# test-speed

1. Baseline: run the file alone twice with `Invoke-TestFile` through catzc-check and keep the second timing; then time `BeforeAll`,
   `BeforeEach` and each `It` with a Stopwatch in a scratch copy under `out/`, count process launches, imports and per-test cache rebuilds,
   find `Get-ChildItem`, `Copy-Item -Recurse`, `New-Item`, `Set-Content` on hot paths and repository-wide scans where one file would do;
   name the cause in one sentence with its evidence (ADR-AUTO-TEST#21).
2. Fix that one cause by its rule: set-up repeated per test builds once in `BeforeAll`, shared read-only (ADR-AUTO-TEST#19); repeated
   imports or spawns of one tree become one import asserted in separate `It` blocks (ADR-AUTO-TEST#20); filesystem cmdlets on a hot path
   become `[System.IO]` or `Copy-Directory`, in the test and the code it exercises (ADR-PWSH-PESTER#9); L2/L3 tests re-proving one wiring
   keep one integration test and move per-case assertions into L0 (ADR-AUTO-TEST#22, #23); a repository-wide check narrows to the files the
   test is about.
3. Prove nothing was lost: same test names (a moved assertion listed with its new home), same or more `Should` assertions, all passing, the
   new timing from two runs, exactly one tier and one category tag per test (ADR-AUTO-TEST#13),
   `Test-ScriptAnalyzer -Path <changed files> -PassThru` at 0; never remove, weaken or skip a test, re-tier it, mock away the integration an
   L2/L3 proves, raise a roof, add an exemption, or edit a file another session has uncommitted.
