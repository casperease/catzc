# pwsh/Base.QualityGates/private/Get-FileMetaScope.ps1

The scope of the file-meta imprint: it lists the tracked files that can carry a meta block, each with its carrier entry.

## help

### synopsis

Lists the tracked files that carry a meta block, each with the carrier entry that says where it goes.

### description

A file is in scope when its class has a front-matter, comment-head or property carrier (a banner and a png, svg or xml stamp are a writer's
alone), the class does not leave it out, an imprint kind's globs match it, and `.gitattributes` does not exempt it or opt it out.

### parameter `RepositoryRoot`

The repository root the returned paths are relative to.

### parameter `Path`

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### parameter `Resolver`

The carrier resolver. Default: built from the shipped file-carriers and languages registries.

### outputs

`[pscustomobject]` @{ Path; Carrier } per file, Path repository-relative and '/'-separated, in git's order.

## Tracked files only

A file named in `-Path` counts only while git tracks it, as a folder lists its tracked files: an untracked authored file carries no head.

## Kind or no kind

Every file whose carrier can hold a head is in scope, whether or not a kind selects it. The imprint renders the whole head from config and
facts, so a file no kind selects gets the empty head, and any block an earlier shape left goes with it.
