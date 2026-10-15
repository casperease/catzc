---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Set-FileLink.ps1.md
    kind: comment-page
    body_sha: bd4044bd7847
    adrs:
      - ADR-AUTO-XPLAT#7
---

# automation/Catzc.Base.Files/Set-FileLink.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `$item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore`.

```text
The no-op path: current means "is a link to the target" — a plain file with identical content is stale,
because replacing the old generated copy with a link is exactly this function's job.
```

## comment:8

Above `$current = if ($IsWindows) {`.

```text
Path equality is case-insensitive on Windows, case-sensitive elsewhere
([ADR-AUTO-XPLAT#7](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat7)).
```

## comment:9

Above ``$existing = [System.IO.File]::ReadAllText($Path) -replace "`r", ''``.

```text
A hard link has no target to read back; link identity plus CR-insensitive content equality is the
honest proxy. A source rewritten by git (new file, old bytes left behind) fails this and re-links.
```

## comment:10

Above `New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction...`.

```text
No symlink privilege — the expected non-admin case. A hard link needs none and the repository
is one volume; a failure here propagates rather than degrading to a copy.
```
