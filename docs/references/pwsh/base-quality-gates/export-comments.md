# pwsh/Base.QualityGates/Export-Comments.ps1

The one-way mover: it takes every long comment out of the repository's code and config files and puts it into the file's comment page.
Build-CommentView puts them back above their code lines for reading, and Test-Comments holds the result to the rules.

## help

### synopsis

Moves every long comment of the repository's code and config files into the file's comment page, one-way.

### description

A long comment leaves the file with nothing behind: its prose moves verbatim into the file's comment page under docs/references as a section
`## comment:N`, which names the code line the comment sat above, so each comment has exactly one living copy
([PDR-ONELIVE-ONEVERSION](../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). Nothing is dropped: Build-CommentView
puts every section back above its code line, and the engine's round-trip test proves the view equals the original. The file's head lists the
page as its `relatives.page`.

What moves is configured in comments.yml
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)): the file
languages in scope, the minimum prose lines, the comment heads each language keeps (`.SYNOPSIS`, `.EXAMPLE`, `#Requires`, …), and where each
folder's pages live. The scope is Get-CommentScope's: tracked files of those languages, test files included, minus vendored, generated,
fixture and contract files and the file kinds comments.yml excludes.

A page that exists already keeps its sections as written; new comments are appended after its highest number, and a number is never reused.
A second run over an exported file changes nothing. Source files keep their own line endings; pages are written canonical. A source-tree
tool: it throws in build mode (Assert-SourceTree).

### parameter `Path`

Files or folders to export. Default: every file in scope.

### parameter `RepositoryRoot`

The repository root paths and pages resolve against. Default: the loaded repository root.

### parameter `StagedFolder`

A staged folder mirroring the repository, relative to the root or absolute: its files are exported in place, and each page is written into
it beside a burst base, read from its staged copy or else from the repository. Default: none, the repository itself.

### parameter `DryRun`

Report what would move without writing any file.

### parameter `PassThru`

Return one Catzc.Base.QualityGates.CommentFileResult per file that changes.

### outputs

`[string[]]` the repository-relative files changed (or, under -DryRun, that would change); with -PassThru, the results.

### example 1

```powershell
Export-Comments -Path pwsh/Base.Files -DryRun -PassThru
```

### example 2

```powershell
Export-Comments -Path pwsh/Base.Files/Write-FileIfChanged.ps1
```

## Staged folders

A staged folder mirrors the repository, and its files are the scope. A page is read from its staged copy, or else from the repository, and
both are written back into the folder. The page goes back with the burst base, which guards a peer's edit.
