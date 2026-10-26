# pwsh/Base.Globs/types/AspectPartition.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<CompiledAspect> Compile(IReadOnlyList<Aspect>...`, written with `//`.

```text
Compile the ordered aspect convention onto a unit root (e.g. "pwsh/Base.Globs"): each
aspect's Include is its own patterns, Exclude is every earlier aspect's patterns, all prefixed by the
unit root. The last aspect (the '**' catch-all) thus becomes "everything under the root minus every
earlier aspect" — the remainder.
```

## comment:2

Above `public static string AspectOf(System.Collections.IDictionary sets, string file)`, written with `//`.

```text
The aspect of one file: the first aspect, in the map's order, one of whose sets claims it; null when none does. The map is
Get-AspectGlobSet's: aspect name -> that aspect's globsets.
```

## comment:3

Above `public static IReadOnlyList<string> Validate(IReadOnlyList<GlobSet>...`, written with `//`.

```text
Partition check ([DDR-ASPECT-PARTITIONISCHECKED](/docs/drs/design/module-aspects.md#rule-ddr-aspect-partitionischecked)) over a file universe: every file
selected by exactly one aspect. Returns
human-readable violations (empty => a valid partition): a file claimed by two aspects breaks disjoint,
a file claimed by none breaks exhaustive.
```
