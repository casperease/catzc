# pwsh/Base.Globs/tests/Get-GlobSetFile.Tests.ps1

The tests of `Get-GlobSetFile`, the member list of a globset.

## What it proves

The member list is the tracked universe intersected with the globset's membership, sorted ordinally
([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly),
[FDR-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)).
