# pwsh/Base.Globs/Get-GlobSetFile.ps1

The member list of a globset: the tracked files the set selects, in ordinal order. It is the exact file list `Get-GlobSetHash` folds into
the set's durable SHA.

## help

### synopsis

Returns the tracked files a globset matches — the deployable unit's actual members.

### description

Intersects the matching universe (`git ls-files`,
[FDR-GLOBS-TRACKEDFILESONLY](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)) with the named globset's membership
(include minus exclude), ordinally sorted — the exact file list the durable SHA is computed over
([FDR-GLOBS-DURABLESHAIDENTITY](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)). A member may be missing on disk
(an unstaged deletion); it is still a member here.

### parameter `Name`

The globset whose members to list.

### example 1

```powershell
Get-GlobSetFile -Name automation
```
