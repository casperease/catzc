# pwsh/Base.QualityGates/private/Get-GitAttributeValue.ps1

The one place the quality gates ask git which classes .gitattributes gives a path, so every scope reads the same classes the same way. It
answers for many paths in one call.

## help

### synopsis

Reads the given .gitattributes attributes for many repository paths at once.

### description

The one place the scopes of the quality gates ask git which file classes .gitattributes declares (vendored, generated, fixture, own title),
so every scope reads the same classes the same way. Runs one `git check-attr` process that reads every path from stdin, NUL-separated both
ways, so no path is quoted or split; a path need not be tracked. Only attributes git reports as set, unset, or a value are returned —
`unspecified` is left out. A root that is not a git work tree has no .gitattributes, so nothing is returned for it.

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Path`

Repository-relative, '/'-separated paths.

### parameter `Attribute`

The attribute names to read.

### outputs

`[hashtable]` path -> @{ `<attribute>` = 'set' | 'unset' | `<value>` }, for the paths with any attribute specified.

## one git process

One `git check-attr` process reads every path from stdin, NUL-separated both ways. A process per batch costs about 25 ms each, and no path
is then quoted or split. A root without a `.git` entry has no .gitattributes to read, so nothing is returned for it, which keeps a test's
scratch root quiet.
