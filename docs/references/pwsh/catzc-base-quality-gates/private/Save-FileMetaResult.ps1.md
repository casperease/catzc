# pwsh/Base.QualityGates/private/Save-FileMetaResult.ps1

Writes the files an engine run found drifted, and names the findings no tool can repair. It is the one writer behind Format-FileMeta and the
file-meta imprint step, so the two cannot disagree.

## help

### synopsis

Writes the files an engine run found drifted, and names the findings no tool can repair.

### description

The one writer behind Format-FileMeta and the file-meta imprint step, so the two cannot disagree. Files are UTF-8 without a BOM.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts).

### parameter `Result`

What Invoke-FileMetaEngine returned.

### parameter `RepositoryRoot`

The repository root the result's paths are relative to.

### parameter `DryRun`

Report what would change without writing any file.

### outputs

`[pscustomobject]` @{ Fixed; Unowned } — Fixed holds the engine's file entries that changed, Unowned the findings left for a person.
