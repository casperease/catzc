# pwsh/Base.Git/tests/Push-Topic.Flow.Tests.ps1

The tests of the git topic flow over a scratch server.

## Why it is L2

A scratch server and clones are made and driven with real git (clone, rebase, push, rev-parse), so the point of the file is the launch.

## The nowhere folder

Every flow command names its clone; a git call that fell back to the loaded repository would land in a folder that is no repository and fail.
