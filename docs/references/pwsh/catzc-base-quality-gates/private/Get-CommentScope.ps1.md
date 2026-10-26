# pwsh/Catzc.Base.QualityGates/private/Get-CommentScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$languageRegistry = Get-Config -Config languages`, written with `#`.

```text
The registry's own ForPath, once: a function call per file costs more than the lookup, and the language test is
cheaper than the globs.
```
