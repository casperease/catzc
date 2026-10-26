# pwsh/Azure.DevOps/Get-AdoYamlFiles.ps1

The function that scans a directory for YAML files and classifies each as Pipeline, Template or Unknown, returning one file record per
file.

## help

### synopsis

Scans a directory recursively for YAML files and classifies each as Pipeline, Template, or Unknown.

### description

Finds all .yml and .yaml files under the specified path, parses each with ConvertFrom-Yaml, and uses top-level key heuristics to classify
the file as an Azure DevOps pipeline, a template (with subtype), or unknown.

Files that fail YAML parsing are included in the output with ParseError set and Classification set to Unknown.

### parameter `Path`

Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.

### parameter `Depth`

How many folder levels below the root the scan descends. The folder-walk config's pruned folders (.git, node_modules, .terraform, …) are
skipped at every level. Defaults to the ado config's yaml_inventory_depth, 6 unless the config sets it.

### example 1

```powershell
Get-AdoYamlFiles -Path 'C:\repos\big-mono'
```

### example 2

```powershell
Get-AdoYamlFiles -Path 'C:\repos\big-mono' -Depth 3
```

## The walk

The scan uses the bounded folder walker, which prunes the folders the folder-walk config excludes (`.git`, `node_modules`, `out`,
`.terraform`, `.ruff_cache` and `.venv` in the shipped config). The depth is the inventory's own.

## Template expressions

ADO template expressions (`${{ if }}`, `${{ each }}`, `${{ parameters.x }}`) are not valid YAML. Before parsing, each is replaced by a
token so the parser can still extract the top-level keys. Every replacement is unique, because identical ones would collide as duplicate
keys.
