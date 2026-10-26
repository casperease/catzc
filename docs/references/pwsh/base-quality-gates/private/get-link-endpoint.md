# pwsh/Base.QualityGates/private/Get-LinkEndpoint.ps1

Builds the endpoint of each distinct path for the link tools: its class, aspect, track, track type and module, each derived from its
declaration. A facet no registry gives stays empty.

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

`[System.Collections.Generic.Dictionary[string, Catzc.Base.QualityGates.LinkEndpoint]]`

## registries read once

The registries are read once per call, never once per path
([ADR-REPO-LINKS-ENDPOINTSAREFACETS](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-endpointsarefacets)).
