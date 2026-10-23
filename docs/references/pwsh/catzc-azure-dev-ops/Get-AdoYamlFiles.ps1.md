# pwsh/Catzc.Azure.DevOps/Get-AdoYamlFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$counter = @{ i = 0 }`, written with `#`.

```text
ADO template expressions (${{ if }}, ${{ each }}, ${{ parameters.x }})
are not valid YAML. Neutralize them so the parser can extract top-level keys.
Each replacement must be unique to avoid duplicate-key errors.
```
