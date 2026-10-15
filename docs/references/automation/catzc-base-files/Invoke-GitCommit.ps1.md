---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Invoke-GitCommit.ps1.md
    kind: reference
    body_sha: "6d07f9b58c2d"
    adrs: []
---

# automation/Catzc.Base.Files/Invoke-GitCommit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A thin, policy-free git wrapper: stages everything under -Path (modified, new, and deleted files —
`git add -A`) and commits exactly those paths with the given message. All policy — branch guards,
CI detection, which paths deserve auto-committing — belongs to the caller.

Idempotent (see [ADR-AUTO-IDEM](/docs/adr/automation/idempotent-state-functions.md)): `git commit` itself is not, so
the wrapper checks first — when `git status --porcelain` reports nothing under -Path, it returns
nothing and runs no side effect. Re-running after a successful commit is a quiet no-op.

Both git invocations run through Invoke-Executable, so the exact commands are logged before they run
([ADR-AUTO-PRELOG](/docs/adr/automation/log-before-invoke.md)) and a non-zero exit throws.
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Return the planned command strings without touching git at all (not even the status check) — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```
