# pwsh/Base.QualityGates/private/Split-CachedFile.ps1

Splits a quality check's files into those its result cache already knows are clean and those to check. It is the read half of a result
cache; Update-ResultCache is the write half.

## help

### synopsis

Splits a quality check's files into those its result cache already knows are clean and those to check.

### description

The read half of a result cache
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)): each
file inside the repository gets the key '`<SHA-256 of its bytes>:<stamp>`'; a file whose cache entry equals its key is cached, every other
file is pending. A file outside the repository, or one that does not exist, is always pending and never keyed (it is never recorded).
Update-ResultCache is the write half.

### parameter `File`

The check's files.

### parameter `Cache`

The result cache (Get-ResultCache).

### parameter `Stamp`

The check's input stamp (Get-ContentStamp).

### parameter `RepositoryRoot`

The repository root.

### parameter `FileStamp`

Each file's own input stamp, by full path: the files beside it that the check's verdict reads (Get-FileMetaInputStamp). A stamped file's key
becomes '`<SHA-256 of its bytes>:<stamp>:<file stamp>`'. Default: none.

### outputs

`[pscustomobject]` { Pending = `string[]` in the given order; CachedCount; Key = full path -> @(relative path, key, file-stamp suffix) }.
