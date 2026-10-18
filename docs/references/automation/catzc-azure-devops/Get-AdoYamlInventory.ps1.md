---
catzc:
  immutable:
    with_body_sha: dafdffdecc9e
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md
    folder: docs/references/automation/catzc-azure-devops
    name: get-ado-yaml-inventory-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Combines YAML file scanning with ADO pipeline registration data.

### description

Runs Get-AdoYamlFiles to classify files by heuristics, then
Get-AdoPipelineDefinitions to fetch registered pipelines from ADO.
Cross-references the two datasets to:

- Mark each file as registered or not.
- Resolve Unknown classifications: if a file is registered as a
  pipeline in ADO, it is reclassified as Pipeline.
- Attach the ADO pipeline name and ID to registered files.

### parameter Path

Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.

### parameter Exclude

Directory names to skip during scanning. Matched as exact names anywhere in the path.
Defaults to @('.git', 'node_modules', '.terraform').

### parameter Project

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter Organization

Azure DevOps organization URL. Defaults to the value in ado.yml.

### example 1

```powershell
Get-AdoYamlInventory -Path 'C:\repos\big-mono'
```

### example 2

```powershell
Get-AdoYamlInventory -Path 'C:\repos\big-mono' | Where-Object { -not $_.IsRegistered -and $_.Classification -eq 'Pipeline' }
```

## comment:1

Above `$pathPrefix = ''`, written with `#`.

```text
ADO YamlPaths are relative to the repo root, but RelativePaths are
relative to the scan root. When scanning a subdirectory (e.g.,
-Path ..\infra\azure-pipelines), there is a prefix mismatch.
Detect it from the data: find a local file whose RelativePath is a
suffix of an ADO YamlPath and extract the prefix.
```
