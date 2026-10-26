# pwsh/Azure.DevOps/Get-AdoPipelineDefinitions.ps1

The function that lists every pipeline definition registered in Azure DevOps, with the YAML file each one points to.

## help

### synopsis

Lists all registered pipeline definitions from Azure DevOps.

### description

Queries the ADO Build Definitions REST API and returns a flattened list of pipeline definitions with their YAML paths, repository names, and
ADO folder placement.

YamlPath is normalized (leading '/' stripped) to match the RelativePath output of Get-AdoYamlFiles for easy cross-referencing.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

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

## Fetching the details

The list call asks for `includeAllProperties`, which should return `process.yamlFilename` inline. Older Azure DevOps Server versions ignore
it, so when no definition carries the file name the function falls back to fetching each definition individually.
