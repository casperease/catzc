# pwsh/Base.QualityGates/private/Get-TerminologyCorpus.ps1

Builds the lower-cased text corpus the terminology orphan check searches, in one bulk read instead of a grep per term. Orphan detection
scans the authored tree, which is wider than the spelling lint scope.

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

## Extension-less files

Authored config files with no extension carry approved vocabulary too: a `*.stackdump` ignore pattern in `.gitignore`, or linguist
attributes in `.gitattributes`. They have no extension for the extension set to match, so they join by name. A term referenced only there is
then not a false orphan.

## Reading

The tree is enumerated and read with `System.IO` rather than `Get-ChildItem`. There is no per-file PSObject wrapping, so a whole-tree scan
is markedly faster
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)). Directory
and name filtering is done inline on the raw path string.

Tracked files reach nine levels below the root, so a depth of ten leaves one level of headroom. The corpus is searched for words and never
read in order, so the walker's file order does not matter.

## Scope

The scope is the one Test-Spelling uses: the `ignorePaths` of the root `cspell.yml`, read as cspell reads them. A glob with no `/` matches a
name at any depth.
