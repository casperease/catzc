---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md
    kind: reference
    body_sha: ef3fb8cad343
    adrs:
      - ADR-AUTO-TEST#25
---

# automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single living copy of "how this repository invokes Pester" (see one-living-version): Run.Path +
PassThru, output verbosity, the run's exclude tags, optionally the NUnit result file (shard workers) and
a full-name filter (the manual single-check path). Both the generated shard scripts
(New-TestAutomationShardScript, via module scope inside the worker) and Invoke-TestFile consume this, so
the two invocation paths cannot drift apart. The strict-mode discipline itself (Set-StrictMode -Version
Latest before Invoke-Pester — tests run strict, see
[ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) stays with the CALLER: strict mode
is
scope-dynamic, so only the scope that invokes Pester can set it for the tests.
```

## comment:2

Section `.PARAMETER EntryScript` of the comment-based help.

```text
The engine entry of a build run (the build's Import-Catzc.ps1), handed to the language bridge so the Go and
Python tests start the build; empty for the source run.
```

## comment:3

Section `.PARAMETER LanguageExecutable` of the comment-based help.

```text
The managed tool per test language and the executable per engine other than pwsh the run's source session
located (Get-LanguageTestExecutable: @{ go = <path>; python = <uv path>; <engine> = <path> }), handed to the
language bridge; an empty entry means there is none.
```

## comment:4

Section `.PARAMETER IncludeTag` of the comment-based help.

```text
Tags a test must carry to run (Pester Filter.Tag) — the -Rule provenance filter. Empty means no include
filter (the default); a test still also has to clear ExcludeTag.
```
