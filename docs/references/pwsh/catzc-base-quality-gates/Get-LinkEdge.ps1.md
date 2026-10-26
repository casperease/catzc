# pwsh/Catzc.Base.QualityGates/Get-LinkEdge.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns every relation into a file, written or derived: the blast radius of changing it.

### description

Reads the relations the files write through the same walk as Test-Links (Invoke-LinkEngine -IncludeEdge) and the relations their
declarations imply (Get-ConventionEdge), over every tracked file, and returns those whose target is the given path
([ADR-REPO-LINKS-CONVENTIONSAREDERIVED](../../../drs/repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)). A folder
takes every relation into what lies under it, so a module's folder answers which modules declare it as a dependency as well as what links
its files; a path that only begins a folder's name is no folder. It needs the source tree: it throws in build mode.

### parameter `To`

The repository path whose incoming relations are wanted, written with either slash.

### parameter `RepositoryRoot`

The repository root. Default: the loaded repository.

### outputs

`[Catzc.Base.QualityGates.LinkEdge]`

## comment:1

Above `[Parameter(Mandatory, Position = 0)]`, written with `#`.

```text
The repository path whose incoming relations are wanted; a folder takes every relation into what lies under
it.
```
