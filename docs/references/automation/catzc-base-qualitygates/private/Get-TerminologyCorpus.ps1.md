---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
    kind: comment-page
    body_sha: "84fa0b849f5c"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$names = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern in
.gitignore, linguist attributes in .gitattributes — but have no extension for $exts to match. Include
them by name so a term referenced only here is not a false orphan (orphan detection scans the whole
authored tree, wider than the lint scope). [System.IO.Path]::GetExtension('.gitignore') is '.gitignore'.
```

## comment:6

Above `$configurationRegex = @(`.

```text
The customer/machine-derived config tree (root configuration/,
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)) and the Bicep template
configuration scaffold are out of the corpus — mirror Test-Spelling's scope. Match ROOT-RELATIVE and
anchored so a nested AUTHORED 'configuration' folder (e.g. docs/adr/configuration/) stays in the corpus
and can justify a term (a bare '[/]configuration[/]' substring would wrongly swallow the ADR folder).
```

## comment:7

Above `$ret = [System.Text.StringBuilder]::new()`.

```text
Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree
scan is markedly faster ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
Directory/name filtering is done inline on the raw path string.
```

## comment:8

Above `foreach ($path in Get-ChildPath $Root -File -Depth 10) {`.

```text
Tracked files reach nine levels below the root, so ten leaves one level of headroom. The corpus is searched for words,
never read in order, so the walker's file order does not matter.
```
