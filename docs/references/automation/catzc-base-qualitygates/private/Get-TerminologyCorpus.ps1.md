---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
    kind: comment-page
    body_sha: df4365e7c671
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Concatenates the lower-cased text of the authored tree so orphan detection can confirm each registry term
is genuinely referenced. The net is deliberately WIDER than Test-Spelling's lint scope: on top of the
spell-scanned extensions it also scans the authored config files with no extension (.gitignore, .gitattributes,
.markdownlintignore, .prettierignore), because a term can be justified solely by a usage there — e.g. a
*.stackdump ignore pattern in .gitignore that the editor's cspell flags but Test-Spelling never scans.
Narrowing the orphan net to the lint scope manufactures false orphans, so it searches the whole tree.

Excludes the registry and its generated dictionaries — where every term trivially appears — so a hit in the
corpus means the term is referenced elsewhere. Returned as one string; the caller tests membership with a
case-insensitive substring check (ordinal, on already-lower-cased text), deliberately lenient: a term
embedded in a larger identifier still counts as referenced.
```

## comment:2

Above `$names = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern in
.gitignore, linguist attributes in .gitattributes — but have no extension for $exts to match. Include
them by name so a term referenced only here is not a false orphan (orphan detection scans the whole
authored tree, wider than the lint scope). [System.IO.Path]::GetExtension('.gitignore') is '.gitignore'.
```

## comment:3

Above `$configurationRegex = @(`.

```text
The customer/machine-derived config tree (root configuration/,
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)) and the Bicep template
configuration scaffold are out of the corpus — mirror Test-Spelling's scope. Match ROOT-RELATIVE and
anchored so a nested AUTHORED 'configuration' folder (e.g. docs/adr/configuration/) stays in the corpus
and can justify a term (a bare '[/]configuration[/]' substring would wrongly swallow the ADR folder).
```

## comment:4

Above `$ret = [System.Text.StringBuilder]::new()`.

```text
Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree
scan is markedly faster ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
Directory/name filtering is done inline on the raw path string.
```
