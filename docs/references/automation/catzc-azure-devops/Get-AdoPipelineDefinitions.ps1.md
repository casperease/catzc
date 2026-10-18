---
catzc:
  immutable:
    with_body_sha: ad282d62831d
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
    folder: docs/references/automation/catzc-azure-devops
    name: get-ado-pipeline-definitions-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists all registered pipeline definitions from Azure DevOps.

### description

Queries the ADO Build Definitions REST API and returns a flattened
list of pipeline definitions with their YAML paths, repository names,
and ADO folder placement.

YamlPath is normalized (leading '/' stripped) to match the RelativePath
output of Get-AdoYamlFiles for easy cross-referencing.

### parameter Project

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter Organization

Azure DevOps organization URL. Defaults to the value in ado.yml.

### example 1

```powershell
Get-AdoPipelineDefinitions
```

### example 2

```powershell
Get-AdoPipelineDefinitions -Organization 'https://dev.azure.com/myorg' -Project 'myproject'
```

### example 3

```powershell
Get-AdoPipelineDefinitions | Where-Object RepositoryName -eq 'big-mono'
```

## comment:1

Above `$hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename }...`, written with `#`.

```text
includeAllProperties should return process.yamlFilename inline.
Older ADO Server versions may ignore this — fall back to per-definition fetches.
```
