# pwsh/Tooling.Listen/private/Get-ListenDiff.ps1

A private helper of the listen module that diffs two files that live outside any repository, with `git diff --no-index`. It is the only
place the module launches git for a diff.

## help

### synopsis

The unified diff of two files outside any repository (git diff --no-index); a missing side diffs as empty.

### description

git diff --no-index exits 1 when the files differ, so the exit code is not asserted. The header lines name the two temporary sides, so the
diff starts at its first hunk, or at git's line for binary files; two equal files yield an empty string. The empty side is a temporary file,
deleted again before the function returns.

### parameter `Before`

The path of the old side; empty or missing for an added file.

### parameter `After`

The path of the new side; empty or missing for a deleted file.

### outputs

`[string]` the diff from its first hunk, or an empty string.
