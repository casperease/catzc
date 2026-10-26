# pwsh/Base.Globs/tests/Get-GlobSetFile.Tests.ps1

The tests of `Get-GlobSetFile`, the member list of a globset.

## What it proves

The member list is the tracked universe intersected with the globset's membership, sorted ordinally
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly),
[FDR-CD-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-durableshaidentity)).
