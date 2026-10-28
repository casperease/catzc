# pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1

The L2 integrity test of `Invoke-TestFile`. It drives a real child pwsh worker through the same generator and runner chain as the harness.
It is tagged greedy: each `It` spawns a full importer-loading pwsh worker, which stacked on the parallel pool oversubscribes the box (see
the greedy tag in the test-automation record).

## The strict fixture

The worker runs every test strict, and a test that genuinely needs non-strict semantics opts out locally, in its own `It` body
([ADR-AUTO-TEST-FILEPARALLELISM](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism)). The fixture holds the
same strict-hostile read (`.Count` on a scalar) twice, bare and behind the opt-out, plus a plain passing test. The bare read fails, so the
same spawn also proves that a failing file reports `Failed` (exit 1) without throwing. How `-FullNameFilter` reaches the worker is proven at
L0, here and in `New-TestAutomationShardScript.Tests.ps1`, so each distinct concern costs one spawn
([ADR-AUTO-TEST-FEWINTEGRATIONTESTS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fewintegrationtests)).

## The snapshot path

The snapshot case is the walking skeleton of the snapshot path
([ADR-AUTO-TEST-RUNSNEVERWAIT](../../../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait)): a real snapshot, primed,
and a real worker loading it. `-Isolated` takes the path deterministically. When the path is taken because another run holds the working
folder is a concern of `Enter-TestRunLocation`'s L1 test. The fixture also carries an L3 block, so the same worker spawn proves that a
snapshot skips the vertical system tests (`Resolve-TestRunMaxLevel`,
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)).
