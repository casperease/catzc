# pwsh/Catzc.Base.Globs/Get-FileAspect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names the aspect of each given file: the first aspect, in aspect order, one of whose globsets claims it.

### description

The aspect sets come from Get-AspectGlobSet, the one place that builds them, once per call however many paths are given. The answer is an
ordered map from each path, in input order, to its aspect name, and an empty string for a file no aspect claims.

### parameter `Path`

The repository-relative, `/`-separated paths to classify.
