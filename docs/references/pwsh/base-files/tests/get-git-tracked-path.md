# pwsh/Base.Files/tests/Get-GitTrackedPath.Tests.ps1

The L0 tests of `Get-GitTrackedPath`: the pathspec and the content-keyed cache against a written index file, and the in-process reader
against this repository's own index.

## The index fixture

A minimal version-2 index of stage-0 regular files is enough: the reader's own shapes are pinned in
`Catzc.Base.Git/tests/types/GitIndex.Tests.ps1`, so here only the seam, the pathspec and the content-keyed cache matter.

## The real repository

On this repository's own index the in-process answer is byte for byte what `git ls-files` prints; an unmerged path, which git repeats per
stage, is counted once.
