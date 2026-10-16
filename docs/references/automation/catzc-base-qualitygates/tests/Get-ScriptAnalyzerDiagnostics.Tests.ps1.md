---
catzc:
  immutable:
    with_body_sha: d6ed233558eb
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-script-analyzer-diagnostics-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ASSETDEP#3
---

# automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ScriptAnalyzerDiagnostics (real vendored analyzer)' -Tag 'L2',...`, written with `#`.

```text
L2: drives the real PSScriptAnalyzer across background-job shards (the whole point of the helper), over
throwaway fixtures. Integrity, because it reads two shipped assets with nothing mocked: the vendored
analyzer (<code root>/.vendor/PSScriptAnalyzer) and the one settings file (<code root>/.internal/assets) — the
real-asset test of [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3),
so it runs in both the source and the build run.
```

## comment:2

Above `It 'shards the real analyzer across a batch: clean file yields none,...`, written with `#`.

```text
One sharded run over a clean + a violating file proves everything the helper must do: the clean file
yields nothing, the violating file yields its rule and path, and diagnostics are aggregated per file
across the batch. Spawning the shards is the L2 cost, so pay it once rather than once per assertion.
```
