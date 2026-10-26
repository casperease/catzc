# pwsh/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Select-TestShardAssignment'`, written with `#`.

```text
Longest-first scheduling of the parallel test files over the worker shards. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `$shards[0] | Should -Be @((& $script:path 'widget'), (& $script:path 'gadget'))`, written with `#`.

```text
widget 9 s on one shard, sprocket 5 + gizmo 4 on the other (9 s each); the two 1 s files then go one to each,
the first to the lower-numbered shard on the tie: 10 s and 10 s.
```

## comment:3

Above `$shards = & $script:assign $files 3 $durations`, written with `#`.

```text
The median of 1 s and 9 s is 9 s (the upper middle), so sprocket ties widget and keeps its given order after
it.
```
