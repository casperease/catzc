# pwsh/Catzc.Base.Files/Write-FileIfChanged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes canonical text to a file only when its content actually changed — the shared primitive behind every idempotent "keep this generated
file current" writer.

### description

Canonicalises the given content (LF endings, exactly one trailing newline) and compares it to what is on disk, ignoring line endings (CR
stripped) — so a CRLF working tree (git core.autocrlf, an editor's format-on-save) never triggers a spurious rewrite (mirrors the
compiled-type cache guard — see [ADR-AUTO-CACHE](../../../drs/automation/caching.md)). Only on a real content difference is the file
written, as UTF-8 without BOM; a missing parent directory is created. Returns whether the file changed (or would change under -DryRun), so a
caller can drive its own status line.

A changed write is delete-then-write, never in-place: writing through a symbolic or hard link at the target path would tunnel the composed
content into the file the link points at, so the write always produces a fresh, independent file.

This is the write tail every generated-artifact builder shares (Build-RootConfig, Build-GitKeep, …) — one living copy of the
canonicalise/compare/write logic instead of one per builder (see [PDR-ONELIVE](../../../drs/principles/one-living-version.md)). It is a
pure primitive: no console output — callers own their reporting.

### parameter `Path`

Path of the target file to write.

### parameter `Content`

The full intended content. Canonicalised before compare and write: CR stripped, trailing newlines collapsed to exactly one.

### parameter `DryRun`

Report whether the file would change without writing it. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### outputs

`[bool]` $true when the file was written (or would be, under -DryRun); $false when already current.

### example 1

```powershell
Write-FileIfChanged -Path $readmePath -Content $composed
```

### example 2

```powershell
Write-FileIfChanged -Path $settingsPath -Content $composed -DryRun
```

## comment:1

Above `[System.IO.File]::Delete($Path)`, written with `#`.

```text
Delete-then-write: an in-place write through a linked target would tunnel the composed content
into the link's source of truth; deleting first severs any link, so the write is always a fresh,
independent file.
```
