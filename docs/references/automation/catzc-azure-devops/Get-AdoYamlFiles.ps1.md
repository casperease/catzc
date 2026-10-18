# automation/Catzc.Azure.DevOps/Get-AdoYamlFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Scans a directory recursively for YAML files and classifies each as Pipeline, Template, or Unknown.

### description

Finds all .yml and .yaml files under the specified path, parses each with ConvertFrom-Yaml, and uses top-level key heuristics to classify
the file as an Azure DevOps pipeline, a template (with subtype), or unknown.

Files that fail YAML parsing are included in the output with ParseError set and Classification set to Unknown.

### parameter Path

Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.

### parameter Exclude

Directory names to skip during scanning. Matched as exact names anywhere in the path. Defaults to @('.git', 'node_modules', '.terraform').

### example 1

```powershell
Get-AdoYamlFiles -Path 'C:\repos\big-mono'
```

### example 2

```powershell
Get-AdoYamlFiles -Path 'C:\repos\big-mono' -Exclude @('.git', 'node_modules', 'vendor')
```

## comment:1

Above `$excludeSet = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
Recurse with [System.IO], PRUNING excluded directories during the walk rather than enumerating the whole
tree (including .git / node_modules / .terraform) and filtering after — Get-ChildItem -Recurse walks every
directory before the -Exclude post-filter ran, which dominated the scan. Raw .NET enumeration also avoids
~20ms/call cmdlet overhead ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:2

Above `$counter = @{ i = 0 }`, written with `#`.

```text
ADO template expressions (${{ if }}, ${{ each }}, ${{ parameters.x }})
are not valid YAML. Neutralize them so the parser can extract top-level keys.
Each replacement must be unique to avoid duplicate-key errors.
```
