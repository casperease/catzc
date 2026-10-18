# pwsh/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the repository-relative Markdown files in the file class the title and the meta block share.

### description

Every git-tracked `*.md` file — the repository as committed, so a gitignored generated README is never in scope while its tracked source is
— minus the files the content tools leave as written (Get-ContentExemptPath: vendored, generated, fixture, or contract asset) and those
whose OptOut attribute .gitattributes marks unset (the meta block's -catzc-meta; the title has none). No list of its own: a new exception is
declared in the .gitattributes source like every other file class.

It rests on [ADR-REPO-FILEMETA#5](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta5) and
[ADR-REPO-FORMAT#6](../../../../adr/repository/uniform-formatting.md#rule-adr-repo-format6).

### parameter `RepositoryRoot`

The repository root the returned paths are relative to.

### parameter `Path`

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### parameter `OptOut`

A `.gitattributes` attribute whose `unset` value takes one file out of this scope. Default: none, every file of the class is in.

### outputs

`[string[]]` repository-relative, '/'-separated paths.

## comment:1

Above `$exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown`, written with `#`.

```text
Every class comes from .gitattributes.
Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
```
