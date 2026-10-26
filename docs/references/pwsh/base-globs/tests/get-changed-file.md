# pwsh/Base.Globs/tests/Get-ChangedFile.Tests.ps1

<!-- cspell:ignore nsrc -->

The tests of `Get-ChangedFile`, the diff universe of the module
([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)).

## What it proves

The changed paths come from `git diff --name-only --no-renames`, repo-relative, with `quotepath` off. A rename is split so that both the old
and the new path count.
