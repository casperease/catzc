---
catzc:
  immutable:
    with_body_sha: "306d60263b29"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-terminology-corpus-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$names = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern in
.gitignore, linguist attributes in .gitattributes — but have no extension for $exts to match. Include
them by name so a term referenced only here is not a false orphan (orphan detection scans the whole
authored tree, wider than the lint scope). [System.IO.Path]::GetExtension('.gitignore') is '.gitignore'.
```

## comment:2

Above `$configurationRegex = @(`, written with `#`.

```text
The customer/machine-derived config tree (root configuration/,
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)) and the Bicep template
configuration scaffold are out of the corpus — mirror Test-Spelling's scope. Match ROOT-RELATIVE and
anchored so a nested AUTHORED 'configuration' folder (e.g. docs/adr/configuration/) stays in the corpus
and can justify a term (a bare '[/]configuration[/]' substring would wrongly swallow the ADR folder).
```

## comment:3

Above `$ret = [System.Text.StringBuilder]::new()`, written with `#`.

```text
Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree
scan is markedly faster ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
Directory/name filtering is done inline on the raw path string.
```

## comment:4

Above `foreach ($path in Get-ChildPath $Root -File -Depth 10) {`, written with `#`.

```text
Tracked files reach nine levels below the root, so ten leaves one level of headroom. The corpus is searched for words,
never read in order, so the walker's file order does not matter.
```
