# pwsh/Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1

The test of `New-TestAutomationShardScript`, the generator of the worker script. L0 cases read the generated script text, and one L2 context
runs a real worker.

## Generated text

The worker and `Invoke-TestFile` must share `New-PesterRunConfiguration`, one living copy of the invocation config, and the worker sets
strict mode before Pester, so tests run strict
([ADR-AUTO-TEST-FILEPARALLELISM](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism)).

The watch type comes from the loaded types, so the watch starts after the importer entry line. It must still start before Pester, so that an
orphaned worker never runs a test file unobserved.

## Real worker

The `worker execution` context is greedy: it spawns a full importer-loading pwsh worker, which stacked on the parallel pool oversubscribes
the box (see the greedy tag in the test-automation ADR). It is also integrity, under
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest):
the real worker imports the shipped, vendored Pester from its code root with nothing mocked. It is the real-asset test and not source-only,
so it runs in the source and the build run.

The live run is the walking skeleton for the whole worker chain: generator, `PesterRunner`, importer, Pester, row sidecar. It uses one real
worker. The per-case behaviour lives in the L0 tests and in the test file of `ConvertTo-TestAutomationRowSet`. Its fixture test file
exercises all row kinds: a pass, a self-skip and a tag-excluded test, plus a pass that proves the worker's Pester is the vendored copy under
the worker's own code root.
