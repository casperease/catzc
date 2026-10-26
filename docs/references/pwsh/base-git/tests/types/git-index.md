# pwsh/Base.Git/tests/types/GitIndex.Tests.ps1

The tests of `GitIndex`, the reader of git's index file.

## Hand-built bytes

The reader is tested against hand-built index bytes in git's on-disk layout (DIRC v2 to v4): every shape a real repository writes, without
launching git. The equivalence with real `git ls-files` is the L2 test in `Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1`.

## The builder

`New-GitIndexBytes` builds index bytes. An entry is a path string or `@{ Path; Stage; Mode; Extended }`; `-Extension` is appended raw after
the entries; the trailer is the SHA-1 of the rest (all zeros with `-ZeroChecksum`, as git writes under `index.skipHash`).
