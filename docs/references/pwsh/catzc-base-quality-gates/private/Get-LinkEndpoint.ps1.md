# pwsh/Catzc.Base.QualityGates/private/Get-LinkEndpoint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the endpoint of each distinct path: its class, aspect, track, track type and module.

### description

Each path's facets are derived from the declarations, never read from its head: the class from file-kinds.yml, the track and its type from
the variants (the track whose place matches the most of the path), the module from module-types.yml, and the aspect from the aspect model
(Get-FileAspect). The paths are normalised to forward slashes and each distinct one is resolved once. A facet no registry gives stays empty.

### parameter `Path`

Repository-relative, '/'-separated paths.

### outputs

A dictionary from path to `[Catzc.Base.QualityGates.LinkEndpoint]`.

## comment:1

Above `$kinds = Get-Config -Config file-kinds`, written with `#`.

```text
The registries are read once per call, never once per path
([ADR-REPO-LINKS-ENDPOINTSAREFACETS](/docs/drs/repository/links-in-repository.md#rule-adr-repo-links-endpointsarefacets)).
```
