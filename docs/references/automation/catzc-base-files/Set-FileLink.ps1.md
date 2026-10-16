---
catzc:
  immutable:
    with_body_sha: c9af362980df
    path: docs/references/automation/catzc-base-files/Set-FileLink.ps1.md
    folder: docs/references/automation/catzc-base-files
    name: set-file-link-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-XPLAT#7
---

# automation/Catzc.Base.Files/Set-FileLink.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
