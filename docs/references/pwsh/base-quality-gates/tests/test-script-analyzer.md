# pwsh/Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1

The test of the `Test-ScriptAnalyzer` gate, in a mocked L0 block and a real-analyzer L2 block.

## Mocked block

The block uses a real file in `$TestDrive`, so the `-Path` collection (`Resolve-Path`) resolves. The analysis helper is mocked, so the
file's contents are irrelevant. The mock is the analysis boundary, the sharded background-job runner, and the unit test never runs the real,
slow analyzer. `Start-Job` processes cannot see Pester mocks, so the seam is the helper and not the cmdlet inside it. The helper has its own
L2 real-analyzer coverage. The mock is set once for the block, and each case sets `$script:diagnostics` for it to return.

## Real analyzer

This block is the real-asset test of
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest).
The gate runs over throwaway files with nothing mocked, so it reads the shipped settings file (`PSScriptAnalyzerSettings.psd1` under the
code root's `.internal/assets`) and the vendored analyzer under the code root's `.vendor`. It is integrity and not source-only, so it runs
in the source and the build run. The repository-wide check that all module code is analyzer-clean is the sharded L2 `PSScriptAnalyzer` test
in `pwsh/.internal/tests`, and is not duplicated here. The block is greedy: the real analyzer fans out `Start-Job` pwsh processes of its
own, stacked on the parallel pool that oversubscribes the box (see the greedy tag in the test-automation record).

One real-analyzer run over a clean file and a violating file proves the boundary end to end. The real analyzer flags the aliased cmdlet with
the repository rule set and reports the clean file as issue-free. The throw path (`IssueCount` above 0 without `-PassThru`) is pure
`Test-ScriptAnalyzer` logic, covered by the mocked block. Here `-PassThru` surfaces the real counts without spawning the analyzer shards a
second time.
