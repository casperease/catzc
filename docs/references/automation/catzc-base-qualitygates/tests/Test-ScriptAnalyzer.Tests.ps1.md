---
catzc:
  immutable:
    with_body_sha: ac79e0ba1fc7
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ScriptAnalyzer.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-script-analyzer-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ASSETDEP#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:targetFile = Join-Path $TestDrive 'subject.ps1'`, written with `#`.

```text
A real file so the -Path collection (Resolve-Path) resolves; the analysis helper is mocked, so the
file's contents are irrelevant.
```

## comment:2

Above `Mock Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates {...`, written with `#`.

```text
Mock the analysis boundary — the sharded background-job runner — never run the real (slow) analyzer
in a unit test. (Start-Job processes cannot see Pester mocks, so the seam is the helper, not the
cmdlet inside it; the helper has its own L2 real-analyzer coverage below.) Mocked once for the block:
each case sets $script:diagnostics for the mock to return.
```

## comment:3

Above `Describe 'Test-ScriptAnalyzer (real analyzer)' -Tag 'L2', 'integrity',...`, written with `#`.

```text
The real-asset test of
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3): the gate runs over
throwaway files with nothing mocked, so it reads
the shipped settings file (<code root>/.internal/assets/PSScriptAnalyzerSettings.psd1) and the vendored
analyzer (<code root>/.vendor) — integrity, and not source-only, so it runs in the source and the build run.
The repo-wide "all module code is analyzer-clean" check is the sharded L2 'PSScriptAnalyzer' test in
automation/.internal/tests — not duplicated here.
greedy: the real analyzer fans out Start-Job pwsh processes of its own — stacked on the parallel pool
that oversubscribes the box (see the test-automation ADR's greedy tag).
```

## comment:4

Above `It 'flags a real aliased-cmdlet violation and passes the clean fixture (real...`, written with `#`.

```text
One real-analyzer run over a clean + a violating file proves the boundary end-to-end: the real analyzer
flags the aliased cmdlet with the repo rule set and reports the clean file as issue-free. The throw path
(IssueCount > 0 without -PassThru) is pure Test-ScriptAnalyzer logic, covered by the mocked L0 block above;
here -PassThru surfaces the real counts without re-spawning the analyzer shards a second time.
```
