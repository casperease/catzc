# pwsh/Base.Globs/Get-FileAspect.ps1

The file-to-aspect lookup: for each path it names the first aspect, in aspect order, one of whose globsets claims it
([DDR-ASPECT](../../../drs/design/module-aspects.md)). It asks `Get-AspectGlobSet` once per call and delegates the matching to
`AspectPartition.AspectOf`.

## help

### synopsis

Names the aspect of each given file: the first aspect, in aspect order, one of whose globsets claims it.

### description

The aspect sets come from Get-AspectGlobSet, the one place that builds them, once per call however many paths are given. The answer is an
ordered map from each path, in input order, to its aspect name, and an empty string for a file no aspect claims.

### parameter `Path`

The repository-relative, `/`-separated paths to classify.
