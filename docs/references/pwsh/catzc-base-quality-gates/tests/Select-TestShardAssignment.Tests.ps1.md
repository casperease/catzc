# pwsh/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Select-TestShardAssignment' -Tag 'L0', 'logic' {`, written with `#`.

```text
Longest-first scheduling of the parallel test files over the worker shards. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `$shards[0] | Should -Be @((& $script:path 'widget'), (& $script:path 'gadget'))`, written with `#`.

```text
widget 9 s on one shard, sprocket 5 + gizmo 4 on the other (9 s each); the two 1 s files then go one to each,
the first to the lower-numbered shard on the tie: 10 s and 10 s.
```
