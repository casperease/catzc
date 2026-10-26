# pwsh/Azure.DevOps/Get-AdoYamlInventory.ps1

The function that joins the YAML file scan with the pipeline definitions registered in Azure DevOps, returning one inventory record per file
with its registration state.

## help

### synopsis

Combines YAML file scanning with ADO pipeline registration data.

### description

Runs Get-AdoYamlFiles to classify files by heuristics, then Get-AdoPipelineDefinitions to fetch registered pipelines from ADO.
Cross-references the two datasets to:

- Mark each file as registered or not.
- Resolve Unknown classifications: if a file is registered as a pipeline in ADO, it is reclassified as Pipeline.
- Attach the ADO pipeline name and ID to registered files.

### parameter `Path`

Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.

### parameter `Depth`

How many folder levels below the root the scan descends, handed to Get-AdoYamlFiles. Defaults to the ado config's yaml_inventory_depth, 6
unless the config sets it.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### example 1

```powershell
Get-AdoYamlInventory -Path 'C:\repos\big-mono'
```

### example 2

```powershell
Get-AdoYamlInventory -Path 'C:\repos\big-mono' | Where-Object { -not $_.IsRegistered -and $_.Classification -eq 'Pipeline' }
```

## The path prefix

ADO `YamlPath` values are relative to the repository root, but the scan's `RelativePath` values are relative to the scan root. Scanning a
subdirectory therefore shows a prefix mismatch. The function detects the prefix from the data: it finds a local file whose `RelativePath` is
a suffix of a registered `YamlPath` and takes the rest of that path as the prefix.
