# pwsh/Base.Git/tests/New-RepositorySnapshot.Tests.ps1

The tests of `New-RepositorySnapshot`: they build snapshots of a throwaway repository and compare them with it.

## Why it is L2

The tests drive real git against a throwaway repository that holds every working-tree state a snapshot must reproduce: staged, unstaged,
staged-then-edited, untracked, deleted and ignored, plus LF bytes under `core.autocrlf=true` (a checkout would rewrite them as CRLF; the
snapshot must not).
