# Manual test plan — Test harness

The test runner, its vendored Pester, fixture-identity hygiene, and this plan's own drift guard. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                   |
| --- | ---- | ------------------------------------------------------- |
| 1   | L1   | [Manual test plan covers every integrity check][c1]     |
| 2   | L1   | [Test-LogicTestIdentity][c2]                            |
| 3   | L1   | [Test-ConfigIdentityHygiene][c3]                        |
| 4   | L1   | [Test-Automation (vendored Pester)][c4]                 |
| 5   | L1   | [Test-InIsolation (vendored Pester)][c5]                |
| 6   | L2   | [Invoke-TestFile (real worker)][c6]                     |
| 7   | L2   | [worker execution (real pwsh through PesterRunner)][c7] |

[c1]: #1-manual-test-plan-covers-every-integrity-check
[c2]: #2-test-logictestidentity
[c3]: #3-test-configidentityhygiene
[c4]: #4-test-automation-vendored-pester
[c5]: #5-test-inisolation-vendored-pester
[c6]: #6-invoke-testfile-real-worker
[c7]: #7-worker-execution-real-pwsh-through-pesterrunner

## Checks

### 1. Manual test plan covers every integrity check

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1` (L1), block
`Manual test plan covers every integrity check`.

**Guards:** the manual test plan stays in sync with the tests (the drift guard for this plan).

**Checks:**

- It AST-discovers every `integrity`-tagged `Describe`/`Context`/`It` across all tests.
- Every discovered `(test file, block)` pair has a check section in a category file, named by its **Test file:** line.
- The number of checks across the category files equals the number of discovered integrity blocks (no stale or duplicate checks).
- The plan has at least one and at most 13 category files.

### 2. Test-LogicTestIdentity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` (L1), block `Test-LogicTestIdentity`.

**Guards:** The automation logic tests use neutral fixtures, not live identities (ADR-REPO-LANG) — no live-identity leaks in the tree.

### 3. Test-ConfigIdentityHygiene

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` (L1), block `Test-ConfigIdentityHygiene`.

**Guards:** The real shipped config stays identity-clean against the fixture-derived token set (no fixture-identity leak into shipped data).

### 4. Test-Automation (vendored Pester)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` (L1), block `Test-Automation (vendored Pester)`.

**Guards:** Test-Automation lazy-loads the vendored Pester from the active code root, and it is the version the session runs.

### 5. Test-InIsolation (vendored Pester)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1` (L1), block `Test-InIsolation (vendored Pester)`.

**Guards:** Test-InIsolation lazy-loads the vendored Pester from the active code root, and it is the version the session runs.

### 6. Invoke-TestFile (real worker)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1` (L2), block `Invoke-TestFile (real worker)`.

**Guards:** The manual single-check entry point runs a strict-hostile file green through the worker chain — harness parity
(ADR-AUTO-TEST-FILEPARALLELISM).

### 7. worker execution (real pwsh through PesterRunner)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1` (L2), block
`worker execution (real pwsh through PesterRunner)`.

**Guards:** A generated shard worker runs in a real pwsh and loads Pester from the active code root's `.vendor/Pester`.
