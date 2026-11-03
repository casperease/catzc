# pwsh/Base.Globs/Get-GlobSetHash.ps1

The durable SHA of a globset, the identity of a deployable unit: one hash over the set's member files, computed on demand and never
committed. It uses the native `DurableHash` primitives for the per-file digests.

## help

### synopsis

Computes a globset's durable SHA — the deployable unit's identity.

### description

The recipe: per member file, SHA-256 over the on-disk bytes with every CR (0x0D) stripped (a CRLF vs LF working tree yields the same
identity on every machine); the per-file digests folded as `<repo-relative-path>|<digest>` lines in ordinal path order; one combined SHA-256
over the fold, returned as 64 lowercase hex chars: the set's live identity, computed on demand and never committed. A
tracked-but-missing-on-disk member (an unstaged deletion) folds the distinct line `<path>|missing` instead of throwing, so a deletion
re-keys the set. Because the path is part of the fold, a rename re-keys even on byte-identical content.

It rests on [FDR-GLOBS-DURABLESHAIDENTITY](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity).

### parameter `Name`

The declared globset (from globs.yml) whose identity to compute.

### parameter `GlobSet`

A `[Catzc.Base.Globs.GlobSet]` instance to compute the identity for instead — the path a DERIVED set (Get-ModuleGlobSet) takes, since
derived sets are not in the declared registry.

### parameter `TrackedFile`

The tracked-file universe (Get-TrackedFile), fetched once by a caller hashing many sets and passed in. Omitted, it is fetched for this call.

### parameter `Digest`

A prefetched map of repository-relative path to `DurableHash` digest (null for a file missing on disk), built once by a caller hashing many
sets (`Get-FileDigest` over the tracked list). A member in the map takes its digest from it; a member the map lacks is hashed from its
bytes. Omitted, the digests of this set's members are fetched for this call.

### example 1

```powershell
Get-GlobSetHash -Name automation
```

### example 2

```powershell
Get-GlobSetHash -GlobSet (Get-ModuleGlobSet -Name Catzc.Base.Globs)
```
