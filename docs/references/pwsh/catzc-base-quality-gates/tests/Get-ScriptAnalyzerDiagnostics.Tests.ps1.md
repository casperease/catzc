# pwsh/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ScriptAnalyzerDiagnostics (real vendored analyzer)' -Tag 'L2',...`, written with `#`.

```text
L2: drives the real PSScriptAnalyzer across background-job shards (the whole point of the helper), over
throwaway fixtures. Integrity, because it reads two shipped assets with nothing mocked: the vendored
analyzer (<code root>/.vendor/PSScriptAnalyzer) and the one settings file (<code root>/.internal/assets) — the
real-asset test of [ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest),
so it runs in both the source and the build run.
```

## comment:2

Above `It 'shards the real analyzer across a batch: clean file yields none,...`, written with `#`.

```text
One sharded run over a clean + a violating file proves everything the helper must do: the clean file
yields nothing, the violating file yields its rule and path, and diagnostics are aggregated per file
across the batch. Spawning the shards is the L2 cost, so pay it once rather than once per assertion.
```
