# pwsh/Base.Globs/tests/types/Aspect.Tests.ps1

The tests of `Aspect` and `AspectPartition`, the ordered first-match partition of a unit's tracked files
([DDR-ASPECT](../../../../../drs/design/module-aspects.md)).

## What it proves

`Compile` encodes each aspect as a leaf scan program, with its own patterns as the include and the earlier aspects' patterns as the exclude.
The last aspect, `**`, becomes the non-live catch-all remainder. `Validate` re-checks that the partition is disjoint and exhaustive.
