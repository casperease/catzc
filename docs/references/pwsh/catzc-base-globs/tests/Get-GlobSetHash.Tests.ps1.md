# pwsh/Base.Globs/tests/Get-GlobSetHash.Tests.ps1

<!-- cspell:ignore ntwo -->

The tests of `Get-GlobSetHash`, the durable SHA of a globset
([FDR-CD-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-durableshaidentity)).

## What it proves

The hash is 64 lowercase hex characters, insensitive to line endings, folded over the path, and in ordinal order. An unstaged deletion folds
the `<path>|missing` marker.
