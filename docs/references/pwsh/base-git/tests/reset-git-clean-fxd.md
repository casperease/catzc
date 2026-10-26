# pwsh/Base.Git/tests/Reset-GitCleanFxd.Tests.ps1

The tests of `Reset-GitCleanFxd`: they pin its classification of clean candidates.

## What is mocked

Git's own dry-run listing is the one external boundary (plus the deleting clean calls); the whitelist itself is mocked to a fixed set, so
these tests exercise pure classification logic.
