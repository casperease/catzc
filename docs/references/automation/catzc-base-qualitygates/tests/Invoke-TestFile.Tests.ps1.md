---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-TestFile.Tests.ps1.md
    kind: test-asset
    body_sha: "68fc466128a1"
    adrs:
      - ADR-AUTO-TEST#23
      - ADR-AUTO-TEST#25
      - ADR-AUTO-TEST#32
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-TestFile (real worker)' -Tag 'L2', 'integrity', 'greedy' {`.

```text
L2: drives a real child pwsh worker through the same generator + runner chain as the harness.
greedy: each It spawns a full importer-loading pwsh worker — stacked on the parallel pool that
oversubscribes the box (see the test-automation ADR's greedy tag).
```

## comment:2

Above `$script:fixture = Join-Path $TestDrive 'StrictHostile.Tests.ps1'`.

```text
The strict contract ([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)): the
worker runs every test strict, and a test that genuinely
needs non-strict semantics opts out locally, in its own It body. The fixture holds the same strict-hostile
read (.Count on a scalar) twice — bare, and behind the opt-out — plus a plain passing test. The bare read
fails, so the same spawn also proves a failing file reports Failed (exit 1) without throwing; how
-FullNameFilter reaches the worker is proven at L0 (here and in New-TestAutomationShardScript.Tests.ps1),
one spawn per distinct concern ([ADR-AUTO-TEST#23](/docs/adr/automation/test-automation.md#rule-adr-auto-test23)).
```

## comment:3

Above `It 'runs in a snapshot: the worker loads the snapshot, the report and the...`.

```text
The walking skeleton of the snapshot path
([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): a real snapshot, primed, a
real worker
loading it. -Isolated takes the path deterministically; when it is taken because another run holds the
working folder is Enter-TestRunLocation's L1 concern.
The fixture also carries an L3 block, so the same worker spawn proves a snapshot skips the vertical system
tests (Resolve-TestRunMaxLevel, [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
```
