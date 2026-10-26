# pwsh/Base.Globs/tests/Get-TrackedFile.Tests.ps1

The tests of `Get-TrackedFile`, the matching universe
([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)).

## What it proves

The tracked files come back as `git ls-files` defines them, repo-relative, answered by `Get-GitTrackedPath` for the whole repository.

## The real index

This repository's own tracked files come back repo-relative with forward slashes, including this test file. They are read in-process from
the real index, so no git process runs. Both counts are wrapped in `@()`, because under the importer's strict mode `.Count` on a scalar, or
on an empty pipeline result, throws instead of adapting.
