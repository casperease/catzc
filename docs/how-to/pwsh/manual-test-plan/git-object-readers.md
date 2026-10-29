# Manual test plan — Git object readers

The in-process readers of git objects, checked against the real repository. Part of the [manual test plan](../manual-test-plan.md), which
says how to run a check.

## Index

| #   | Tier | Check                                         |
| --- | ---- | --------------------------------------------- |
| 1   | L2   | [Get-GitCommitTree — the real repository][c1] |
| 2   | L2   | [Get-GitBlobText — the real repository][c2]   |

[c1]: #1-get-gitcommittree--the-real-repository
[c2]: #2-get-gitblobtext--the-real-repository

### 1. Get-GitCommitTree — the real repository

**Test file:** `pwsh/Base.Files/tests/Get-GitCommitTree.Tests.ps1` (L2), block `Get-GitCommitTree — the real repository`.

**Guards:** the in-process commit tree reader lists exactly the paths `git ls-tree` lists for `HEAD`.

**Checks:**

- The paths `Get-GitCommitTree` returns equal, in order, the paths of `git ls-tree -r --name-only -z HEAD`.

**Prerequisite:** git.

### 2. Get-GitBlobText — the real repository

**Test file:** `pwsh/Base.Files/tests/Get-GitBlobText.Tests.ps1` (L2), block `Get-GitBlobText — the real repository`.

**Guards:** the in-process blob reader returns a committed file's text as `git cat-file blob` prints it.

**Checks:**

- The text of the committed `importer.ps1` blob, end of line trimmed, equals the output of `git cat-file blob`.

**Prerequisite:** git.
