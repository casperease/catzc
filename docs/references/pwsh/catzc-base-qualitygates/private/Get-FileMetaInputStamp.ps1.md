# pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Stamps, per file, the files beside it that its meta block is read from, so a file-meta result cache never serves a stale head.

### description

A file's head is not a function of its own bytes alone: the cites are read from its comment page as well, and a relation's edge names the
first of its candidates on disk. So each file's stamp hashes its comment page's bytes (or that it is missing) and, for every relation of a
kind that declares relations, whether each candidate (Get-RelativeEdgeCandidate) is on disk. Split-CachedFile joins the stamp to the file's
key ([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../adr/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)), so
a change beside the file checks it again.

### parameter `File`

The files to stamp.

### parameter `RepositoryRoot`

The repository root.

### parameter `Config`

The file-meta registry. Default: the loaded one.

### outputs

`[hashtable]` full path -> the stamp, a SHA-256 in hex.
