# pwsh/Base.QualityGates/private/Get-MarkdownScope.ps1

Lists the repository-relative Markdown files in the file class that the title and the meta block share. One scope keeps the two checks on
the same files.

## help

### synopsis

Lists the repository-relative Markdown files in the file class the title and the meta block share.

### description

Every git-tracked `*.md` file — the repository as committed, so a gitignored generated README is never in scope while its tracked source is
— minus the files the content tools leave as written (Get-ContentExemptPath: vendored, generated, fixture, or contract asset) and those
whose OptOut attribute .gitattributes marks unset (the meta block's -catzc-meta; the title has none). No list of its own: a new exception is
declared in the .gitattributes source like every other file class.

It rests on [ADR-REPO-FILEMETA-KINDSCOPE](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-kindscope) and
[ADR-REPO-FORMAT-MARKDOWNTITLE](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-markdowntitle).

### parameter `RepositoryRoot`

The repository root the returned paths are relative to.

### parameter `Path`

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### parameter `OptOut`

A `.gitattributes` attribute whose `unset` value takes one file out of this scope. Default: none, every file of the class is in.

### outputs

`[string[]]` repository-relative, '/'-separated paths.

## Exempt paths

Every exempt class comes from `.gitattributes`. Get-ContentExemptPath returns its paths as one array, so the result is assigned to a
variable first, and the exempt set then holds the paths, not the array.
