---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Select-TestShardAssignment.Tests.ps1.md
    kind: test-asset
    body_sha: "558a7614e3b1"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Select-TestShardAssignment' -Tag 'L0', 'logic' {`.

```text
Longest-first scheduling of the parallel test files over the worker shards. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$shards[0] | Should -Be @((& $script:path 'widget'), (& $script:path 'gadget'))`.

```text
widget 9 s on one shard, sprocket 5 + gizmo 4 on the other (9 s each); the two 1 s files then go one to each,
the first to the lower-numbered shard on the tie: 10 s and 10 s.
```
