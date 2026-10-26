# pwsh/Base.QualityGates/Get-LinkEdge.ps1

The blast radius of a change: it returns every relation into a path, both the ones a file writes and the ones derived by convention, from
the same walk and declarations as Test-LinkDirections.

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

## Path

The path is a repository path. A folder takes every relation into what lies under it.
