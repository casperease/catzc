# pwsh/Catzc.Base.QualityGates/private/Get-GitAttributeValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the given .gitattributes attributes for many repository paths at once.

### description

The one place the scopes of the quality gates ask git which file classes .gitattributes declares (vendored, generated, fixture, own title),
so every scope reads the same classes the same way. Runs `git check-attr` in batches that keep each command line short; a path need not be
tracked. Only attributes git reports as set, unset, or a value are returned — `unspecified` is left out. A root that is not a git work tree
has no .gitattributes, so nothing is returned for it.

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Path`

Repository-relative, '/'-separated paths.

### parameter `Attribute`

The attribute names to read.

### outputs

`[hashtable]` path -> @{ `<attribute>` = 'set' | 'unset' | `<value>` }, for the paths with any attribute specified.
