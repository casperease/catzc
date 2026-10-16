---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoYamlFiles.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3790294fa343"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Azure.DevOps/Get-AdoYamlFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
