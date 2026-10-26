# pwsh/Base.QualityGates/private/Get-CommentScope.ps1

The one scope the comment tools share: the files whose long comments live in a comment page, each with its file language and page. The
exporter, the view builder and the gate all read it, so they cannot disagree about which files are in play.

## help

### synopsis

Lists the files whose long comments live in a comment page, each with its file language and page.

### description

The one scope Export-Comments, Build-CommentView and Test-Comments share, so the converter, the view and the gate can never disagree. It
starts from the files Get-LinkScope lists (the tracked files, or the given -Path, minus every file the content tools leave as written) and
keeps a file when its file language is one comments.yml names, comments.yml maps it to a page, and its file kind is none that comments.yml
excludes (assets and test input fixtures; tests, their fixtures and assets only when comments.yml declares no `exclude:`, so test files are
in scope)
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Path`

Optional files or folders to limit the scope to.

### outputs

`[pscustomobject]` { File, Extension, Language, Page } per file, in path order.

## cost of the lookup

The language lookup uses the registry's own `ForPath`, taken once before the loop. A function call per file costs more than the lookup, and
the language test is cheaper than the page lookup, so it runs first.

## untracked files

With the repository root the loaded one and a candidate list, files git does not track are checked in batches of fifty with
`git check-ignore --no-index`, and the ignored ones (build output) are dropped. New untracked files stay in scope. Exit code 1 means none
are ignored, and any code above 1 is a git failure that throws.
