# pwsh/Base.Globs/Get-AspectGlobSet.ps1

The one place that builds every aspect's globsets, from the aspect model alone: an ordered map of aspect name to the globsets of that
aspect, made of `Get-ModuleGlobSet`'s module-layer aspect sets and each aspect-declaring track's, one unit per place.

## help

### synopsis

Builds every aspect's globsets, from the aspect model alone: the one place that builds them.

### description

Each module-layer set of Get-ModuleGlobSet joins the aspect its name ends in, a single-file module's set joins `live`, and each track that
declares aspects compiles them per place into sets of its own, so every file a track holds is claimed by exactly one aspect
([DDR-ASPECT-ASPECTISAGLOBSET](../../../drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset)).

### outputs

`[System.Collections.Specialized.OrderedDictionary]` aspect name to the globsets of that aspect, in aspect order.

## Single-file modules

A single-file module's set is the degenerate one-aspect partition: `live`
([DDR-ASPECT-ASPECTISAGLOBSET](../../../drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset)).
