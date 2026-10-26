# pwsh/Base.QualityGates/private/Get-TerminologyCorpus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the lower-cased text corpus the terminology orphan check searches — one bulk read, not a grep per term.

### description

Concatenates the lower-cased text of the authored tree so orphan detection can confirm each registry term is genuinely referenced. The net
is deliberately WIDER than Test-Spelling's lint scope: on top of the spell-scanned extensions it also scans the authored config files with
no extension (.gitignore, .gitattributes, .markdownlintignore, .prettierignore), because a term can be justified solely by a usage there —
e.g. a `*.stackdump` ignore pattern in .gitignore that the editor's cspell flags but Test-Spelling never scans. Narrowing the orphan net to
the lint scope manufactures false orphans, so it searches the whole tree.

Excludes the registry and its generated dictionaries — where every term trivially appears — so a hit in the corpus means the term is
referenced elsewhere. Returned as one string; the caller tests membership with a case-insensitive substring check (ordinal, on
already-lower-cased text), deliberately lenient: a term embedded in a larger identifier still counts as referenced.

### parameter `Root`

The repository root to scan under.

### parameter `Exclude`

Full paths to omit from the corpus (the registry file and the generated dictionaries).

### outputs

`[string]` The concatenated, lower-cased corpus.

## comment:1

Above `$names = [System.Collections.Generic.HashSet[string]]::new(`, written with `#`.

```text
Authored config files with no extension carry approved vocabulary too — a *.stackdump ignore pattern in
.gitignore, linguist attributes in .gitattributes — but have no extension for $exts to match. Include
them by name so a term referenced only here is not a false orphan (orphan detection scans the whole
authored tree, wider than the lint scope). [System.IO.Path]::GetExtension('.gitignore') is '.gitignore'.
```

## comment:2

Above `$ret = [System.Text.StringBuilder]::new()`, written with `#`.

```text
Enumerate with [System.IO] rather than Get-ChildItem — no per-file PSObject wrapping, so a whole-tree
scan is markedly faster ([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
Directory/name filtering is done inline on the raw path string.
```

## comment:3

Above `foreach ($path in Get-ChildPath $Root -File -Depth 10) {`, written with `#`.

```text
Tracked files reach nine levels below the root, so ten leaves one level of headroom. The corpus is searched for words,
never read in order, so the walker's file order does not matter.
```

## comment:4

Above `$ignored = @(foreach ($glob in...`, written with `#`.

```text
Test-Spelling's one scope: the ignorePaths of the root cspell.yml, read as cspell reads them, where a glob with no
'/' matches a name at any depth.
```
