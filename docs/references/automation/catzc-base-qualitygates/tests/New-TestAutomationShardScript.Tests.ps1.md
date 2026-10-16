---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/New-TestAutomationShardScript.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3b751653ee2f"
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-TEST#25
---

# automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:content | Should -Match 'New-PesterRunConfiguration'`, written with `#`.

```text
The worker and Invoke-TestFile must share New-PesterRunConfiguration (one living copy of the
invocation config) and the worker sets strict mode before Pester, so tests run strict
([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)).
```

## comment:2

Above `$entry = $script:content.IndexOf("importer.ps1' -SkipJanitors")`, written with `#`.

```text
The watch type comes from the loaded types, so the watch starts after the entry line; it must start
before Pester so an orphaned worker never runs a test file unobserved.
```

## comment:3

Above `Context 'worker execution (real pwsh through PesterRunner)' -Tag 'L2',...`, written with `#`.

```text
greedy: spawns a full importer-loading pwsh worker — stacked on the parallel pool that
oversubscribes the box (see the test-automation ADR's greedy tag).
integrity + [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3):
the real worker imports the shipped, vendored Pester from its code root,
nothing mocked — the real-asset test, not source-only, so it runs in the source and the build run.
```

## comment:4

Above `$runDirectory = Join-Path $TestDrive 'live-run'`, written with `#`.

```text
The walking skeleton for the whole worker chain: generator → PesterRunner → importer →
Pester → row sidecar. One real worker; the per-case behaviour lives in the L0 tests above
and in ConvertTo-TestAutomationRowSet's own test file.
```

## comment:5

Above `$fixture = Join-Path $TestDrive 'ShardFixture.Tests.ps1'`, written with `#`.

```text
A fixture test file exercising all row kinds: a pass, a self-skip, and a tag-excluded test — plus a
pass proving the worker's Pester is the vendored copy under the worker's own code root.
```
