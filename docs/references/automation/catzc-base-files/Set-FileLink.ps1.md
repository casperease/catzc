# automation/Catzc.Base.Files/Set-FileLink.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Materialises a file as a filesystem link to a source of truth — the link sibling of Write-FileIfChanged.

### description

Ensures the file at -Path is a link to the file at -Target, so the two are one file by construction and drift is impossible. Idempotent
(check before acting): an existing artifact counts as current only when it is a symbolic link resolving to the target, or a hard link whose
bytes are CR-insensitively identical to the target. Anything else — a plain file (an old generated copy, even with identical content), a
symbolic link to the wrong place, a hard link orphaned by a git rewrite of the source — is deleted and recreated.

Creation depends on the platform: a relative symbolic link everywhere it is permitted; on Windows without the symlink privilege (the
enterprise default — no admin, no Developer Mode) a hard link, which needs no privilege since the repository is one volume. When neither
works the function throws — it never degrades to a content copy, which would silently reintroduce the drift the link exists to remove.

A pure primitive like Write-FileIfChanged: no console output — callers own their reporting. See
[ADR-REPO-ROOTCFG](../../../adr/repository/generated-root-configs.md).

### parameter Path

Path of the link file to create or verify.

### parameter Target

Path of the source file, which must exist, that the link must resolve to.

### parameter DryRun

Report whether the link would change without touching the filesystem. See [ADR-AUTO-DRYRUN](../../../adr/automation/dry-run.md).

### outputs

`[bool]` $true when the link was (re)created (or would be, under -DryRun); $false when already current.

### example 1

```powershell
Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath
```

### example 2

```powershell
Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath -DryRun
```

## comment:1

Above `$item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore`, written with `#`.

```text
The no-op path: current means "is a link to the target" — a plain file with identical content is stale,
because replacing the old generated copy with a link is exactly this function's job.
```

## comment:2

Above `$current = if ($IsWindows) {`, written with `#`.

```text
Path equality is case-insensitive on Windows, case-sensitive elsewhere
([ADR-AUTO-XPLAT#7](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat7)).
```

## comment:3

Above ``$existing = [System.IO.File]::ReadAllText($Path) -replace "`r", ''``, written with `#`.

```text
A hard link has no target to read back; link identity plus CR-insensitive content equality is the
honest proxy. A source rewritten by git (new file, old bytes left behind) fails this and re-links.
```

## comment:4

Above `New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction...`, written with `#`.

```text
No symlink privilege — the expected non-admin case. A hard link needs none and the repository
is one volume; a failure here propagates rather than degrading to a copy.
```
