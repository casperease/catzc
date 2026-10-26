# pwsh/Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1

The L2 integrity test of `Get-ScriptAnalyzerDiagnostics`. It drives the real PSScriptAnalyzer across background-job shards, which is the
point of the helper, over throwaway fixtures.

## Why integrity

The test reads two shipped assets with nothing mocked: the vendored analyzer under the code root's `.vendor/PSScriptAnalyzer`, and the one
settings file under its `.internal/assets`. It is the real-asset test of
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest),
so it runs in both the source and the build run.

## One run

A single sharded run over a clean file and a violating file proves all the helper must do. The clean file yields nothing, the violating file
yields its rule and path, and diagnostics are aggregated per file across the batch. Spawning the shards is the L2 cost, so the test pays it
once rather than once per assertion.
