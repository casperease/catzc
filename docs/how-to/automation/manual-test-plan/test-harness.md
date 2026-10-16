---
catzc:
  immutable:
    with_body_sha: "405dd3ce034b"
    path: docs/how-to/automation/manual-test-plan/test-harness.md
    folder: docs/how-to/automation/manual-test-plan
    name: test-harness
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-TEST#25
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — Test harness

The test runner, its vendored Pester, fixture-identity hygiene, and this plan's own drift guard. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                        | FullNameFilter                                    | Guards                                                                                                                             |
| --- | ---- | -------------------------------------------------------------------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1       | Manual test plan covers every integrity check     | The plan's category files list every integrity check, with no stale rows.                                                          |
| 2   | L1   | automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1        | Test-LogicTestIdentity                            | The automation logic tests use neutral fixtures, not live identities (ADR-REPO-LANG) — no live-identity leaks in the tree.         |
| 3   | L1   | automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1    | Test-ConfigIdentityHygiene                        | The real shipped config stays identity-clean against the fixture-derived token set (no fixture-identity leak into shipped data).   |
| 4   | L1   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1               | Test-Automation (vendored Pester)                 | Test-Automation lazy-loads the vendored Pester from the active code root, and it is the version the session runs.                  |
| 5   | L1   | automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1              | Test-InIsolation (vendored Pester)                | Test-InIsolation lazy-loads the vendored Pester from the active code root, and it is the version the session runs.                 |
| 6   | L2   | automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1               | Invoke-TestFile (real worker)                     | The manual single-check entry point runs a strict-hostile file green through the worker chain — harness parity (ADR-AUTO-TEST#25). |
| 7   | L2   | automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1 | worker execution (real pwsh through PesterRunner) | A generated shard worker runs in a real pwsh and loads Pester from the active code root's `.vendor/Pester`.                        |

## Checks

### 1. Manual test plan covers every integrity check

**Guards:** the manual test plan stays in sync with the tests (the drift guard for this plan).

**Checks:**

- It AST-discovers every `integrity`-tagged `Describe`/`Context`/`It` across all tests.
- Every discovered `(test file, block)` pair has a row in a category file's index table.
- The number of index rows across the category files equals the number of discovered integrity blocks (no stale or duplicate rows).
- The plan has at least one and at most 13 category files.
