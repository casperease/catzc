---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md
    kind: comment-page
    body_sha: "221209baf4db"
    adrs: []
---

# automation/Catzc.Base.Files/Write-FileIfChanged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Canonicalises the given content (LF endings, exactly one trailing newline) and compares it to what is on
disk, ignoring line endings (CR stripped) — so a CRLF working tree (git core.autocrlf, an editor's
format-on-save) never triggers a spurious rewrite (mirrors the compiled-type cache guard — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). Only on a real content difference is the file written, as UTF-8
without
BOM; a missing parent directory is created. Returns whether the file changed (or would change under
-DryRun), so a caller can drive its own status line.

A changed write is delete-then-write, never in-place: writing through a symbolic or hard link at the
target path would tunnel the composed content into the link's source of truth (a Set-FileLink target that
an entry stopped declaring), so the write always produces a fresh, independent file.

This is the write tail every generated-artifact builder shares (Build-RootConfig, Build-GitKeep, …) —
one living copy of the canonicalise/compare/write logic instead of one per builder (see
[ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)). It is a pure primitive: no console output — callers
own
their reporting.
```

## comment:2

Section `.PARAMETER Content` of the comment-based help.

```text
The full intended content. Canonicalised before compare and write: CR stripped, trailing newlines
collapsed to exactly one.
```

## comment:3

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report whether the file would change without writing it. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:4

Above `[System.IO.File]::Delete($Path)`.

```text
Delete-then-write: an in-place write through a linked target would tunnel the composed content
into the link's source of truth; deleting first severs any link, so the write is always a fresh,
independent file.
```
