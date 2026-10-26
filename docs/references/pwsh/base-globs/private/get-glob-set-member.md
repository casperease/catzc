# pwsh/Base.Globs/private/Get-GlobSetMember.ps1

The private single source of a set's included members: the tracked files the globset finally selects, which `Get-GlobSetFile` and
`Get-GlobSetHash` build on.

## help

### synopsis

The tracked files a globset finally selects — the single source of a set's included members.

### description

The one definition of "what is IN the package"
([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)): the matching universe
(`git ls-files`) intersected with the set's final membership (GlobSet.Matches, last-match-wins), ordinal-sorted. Every consumer of the
member list routes through here — the durable content SHA (Get-GlobSetHash), the public Get-GlobSetFile — so the scoped list can never drift
between the hash and the public file list. A member may be missing on disk (an unstaged deletion); it is still a member.

### parameter `GlobSet`

The globset instance to resolve (declared or derived).

### parameter `TrackedFile`

The tracked-file universe (Get-TrackedFile), fetched once by a caller resolving many sets and passed in. Omitted, it is fetched for this
call.

### example 1

```powershell
Get-GlobSetMember -GlobSet (Get-GlobSet -Name automation)
```
