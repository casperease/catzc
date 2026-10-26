# pwsh/Base.QualityGates/private/Get-ScopeLookup.ps1

Turns the optional files or folders of a scope into the repository-relative paths git is asked about. A gate that takes `-Path` uses it to
resolve the paths once, the same way.

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

## Relative paths

A relative path is the caller's own when they stand inside this repository, and the repository's otherwise. A snapshot run stands elsewhere,
so the repository root is the fallback.

## Lost files

A path the index lists but the working tree has lost, such as a deletion not yet staged, stays in scope. The reader skips it.
