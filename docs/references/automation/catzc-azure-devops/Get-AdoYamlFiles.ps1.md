---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoYamlFiles.ps1.md
    kind: reference
    body_sha: d765d9ee9ef9
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Azure.DevOps/Get-AdoYamlFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Finds all .yml and .yaml files under the specified path, parses each with
ConvertFrom-Yaml, and uses top-level key heuristics to classify the file
as an Azure DevOps pipeline, a template (with subtype), or unknown.

Files that fail YAML parsing are included in the output with ParseError set
and Classification set to Unknown.
```

## comment:2

Section `.PARAMETER Exclude` of the comment-based help.

```text
Directory names to skip during scanning. Matched as exact names anywhere in the path.
Defaults to @('.git', 'node_modules', '.terraform').
```

## comment:3

Above `$excludeSet = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Recurse with [System.IO], PRUNING excluded directories during the walk rather than enumerating the whole
tree (including .git / node_modules / .terraform) and filtering after — Get-ChildItem -Recurse walks every
directory before the -Exclude post-filter ran, which dominated the scan. Raw .NET enumeration also avoids
~20ms/call cmdlet overhead ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:4

Above `$counter = @{ i = 0 }`.

```text
ADO template expressions (${{ if }}, ${{ each }}, ${{ parameters.x }})
are not valid YAML. Neutralize them so the parser can extract top-level keys.
Each replacement must be unique to avoid duplicate-key errors.
```
