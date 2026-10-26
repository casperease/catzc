# pwsh/Base.Globs/tests/Get-GlobSetMember.Tests.ps1

The tests of `Get-GlobSetMember`, the single source of what is in a set
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)).

## What it proves

The members are `git ls-files` intersected with `GlobSet.Matches`, sorted ordinally. The function is private, so the test calls it through
the module, and the `_` arguments of the script block take the set and the mocked tree.
