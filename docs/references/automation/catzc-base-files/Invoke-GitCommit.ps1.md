# automation/Catzc.Base.Files/Invoke-GitCommit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Commits the changes under the given repository paths as one git commit.

### description

A thin, policy-free git wrapper: stages everything under -Path (modified, new, and deleted files — `git add -A`) and commits exactly those
paths with the given message. All policy — branch guards, CI detection, which paths deserve auto-committing — belongs to the caller.

Idempotent (see [ADR-AUTO-IDEM](../../../adr/automation/idempotent-state-functions.md)): `git commit` itself is not, so the wrapper checks
first — when `git status --porcelain` reports nothing under -Path, it returns nothing and runs no side effect. Re-running after a successful
commit is a quiet no-op.

Both git invocations run through Invoke-Executable, so the exact commands are logged before they run
([ADR-AUTO-PRELOG](../../../adr/automation/log-before-invoke.md)) and a non-zero exit throws.

### parameter `Path`

The repository-relative, '/'-separated paths (files or folders) whose changes make up the commit.

### parameter `Message`

The commit message. Double quotes are rejected — the message is embedded in a quoted command string.

### parameter `DryRun`

Return the planned command strings without touching git at all (not even the status check) — see
[ADR-AUTO-DRYRUN](../../../adr/automation/dry-run.md).

### outputs

`[string]` The new commit's full SHA; the planned commands with -DryRun; nothing when there was nothing to commit.

### example 1

```powershell
Invoke-GitCommit -Path 'automation/.compiled' -Message 'chore(repo): sync compiled types'
```

### example 2

```powershell
Invoke-GitCommit -Path 'automation/.compiled', 'out' -Message 'sync' -DryRun
```
