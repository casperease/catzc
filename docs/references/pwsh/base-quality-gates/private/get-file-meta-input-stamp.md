# pwsh/Base.QualityGates/private/Get-FileMetaInputStamp.ps1

The stamp of the files beside a file that its meta block is read from. A file-meta result cache joins it to the file's key, so a change to
the comment page or to a relation's candidate checks the file again.

## help

### synopsis

Stamps, per file, the files beside it that its meta block is read from, so a file-meta result cache never serves a stale head.

### description

A file's head is not a function of its own bytes alone: the cites are read from its comment page as well, and a relation's edge names the
first of its candidates on disk. So each file's stamp hashes its comment page's bytes (or that it is missing) and, for every relation of a
kind that declares relations, whether each candidate (Get-RelativeEdgeCandidate) is on disk. Split-CachedFile joins the stamp to the file's
key ([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)), so a change beside
the file checks it again. A file whose cites the drs-codes kind writes also hashes the registered codes, and a repository with no DRS index
has no codes: its files hash an empty set and are checked again once the index exists.

### parameter `File`

The files to stamp.

### parameter `RepositoryRoot`

The repository root.

### parameter `Config`

The file-meta registry. Default: the loaded one.

### outputs

`[hashtable]` full path -> the stamp, a SHA-256 in hex.
