# pwsh/Base.QualityGates/private/Get-ScopeLookup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Turns the optional files or folders of a scope into the repository-relative paths git is asked about.

### description

No path means the whole repository; a path outside the repository root is refused. A path the working tree has lost stays in scope while the
index still lists it, a deletion not yet staged, so the reader skips it; a path neither on disk nor tracked is refused.

### parameter `RepositoryRoot`

The repository root the returned paths are relative to.

### parameter `Path`

Optional files or folders (absolute or relative to the current location).

### parameter `Command`

The name of the calling command, for the refusal message.

### outputs

`[string[]]` repository-relative, '/'-separated paths, or '.' for the whole repository.

## comment:1

Above `$here = (Get-Location).ProviderPath`, written with `#`.

```text
A relative path is the caller's own when they stand inside this repository, else the repository's: a snapshot run
stands elsewhere.
```

## comment:2

Above `if (-not (Test-Path -LiteralPath $full)) {`, written with `#`.

```text
A path the index lists but the working tree has lost, a deletion not yet staged, stays in scope; the reader
skips it.
```
