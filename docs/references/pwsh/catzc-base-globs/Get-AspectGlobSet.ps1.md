# pwsh/Catzc.Base.Globs/Get-AspectGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds every aspect's globsets, from the aspect model alone: the one place that builds them.

### description

Each module-layer set of Get-ModuleGlobSet joins the aspect its name ends in, a single-file module's set joins `live`, and each track that
declares aspects compiles them per place into sets of its own, so every file a track holds is claimed by exactly one aspect
([DDR-ASPECT-ASPECTISAGLOBSET](../../../drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset)).

### outputs

`[System.Collections.Specialized.OrderedDictionary]` aspect name to the globsets of that aspect, in aspect order.

## comment:1

Above `$aspectSet = [ordered]@{}`, written with `#`.

```text
Aspect name to the globsets of that aspect, from the aspect model alone: Get-ModuleGlobSet's module-layer aspect sets and each
aspect-declaring track's, one unit per place.
```

## comment:2

Above `$singleFile = @(Get-CatzcModule -Track $codeTrack.name...`, written with `#`.

```text
A single-file module's set is the degenerate one-aspect partition: live
([DDR-ASPECT-ASPECTISAGLOBSET](/docs/drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset)).
```
