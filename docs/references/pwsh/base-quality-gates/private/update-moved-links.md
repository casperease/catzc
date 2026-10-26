# pwsh/Base.QualityGates/private/Update-MovedLinks.ps1

The re-pointing half of `Format-Links -MoveMap`: given a map of moved files, it rewrites every Markdown link that a move broke, so a whole
tree of renames repairs its links in one pass.

## help

### synopsis

Re-points the relative Markdown links that a set of file moves broke.

### description

Reads each Markdown file of `-File` and resolves every relative link from where the file stood before the move (its old path, when the file
itself moved). A link whose target moved is rewritten to the target's new path, written from where the file stands now; a link neither end
of which moved is left exactly as written. URLs, rooted paths and anchors-only links are never touched, and the anchor of a rewritten link is
kept. It writes nothing: the caller writes the returned texts.

### parameter `RepositoryRoot`

The root the paths of `-File` and `-Map` are relative to.

### parameter `File`

The repository-relative files to read; only `.md` files are rewritten.

### parameter `Map`

The moves, old repository-relative path to new.

### outputs

`[hashtable]` the changed files only: repository-relative path to its rewritten text.
