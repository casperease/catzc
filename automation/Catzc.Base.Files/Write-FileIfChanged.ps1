<#
.SYNOPSIS
    Writes canonical text to a file only when its content actually changed — the shared primitive behind
    every idempotent "keep this generated file current" writer.
.DESCRIPTION
    Canonicalises the given content (LF endings, exactly one trailing newline) and compares it to what is on
    disk, ignoring line endings (CR stripped) — so a CRLF working tree (git core.autocrlf, an editor's
    format-on-save) never triggers a spurious rewrite (mirrors the compiled-type cache guard — see
    docs/adr/automation/caching.md). Only on a real content difference is the file written, as UTF-8 without
    BOM; a missing parent directory is created. Returns whether the file changed (or would change under
    -DryRun), so a caller can drive its own status line.

    A changed write is delete-then-write, never in-place: writing through a symbolic or hard link at the
    target path would tunnel the composed content into the link's source of truth (a Set-FileLink target that
    an entry stopped declaring), so the write always produces a fresh, independent file.

    This is the write tail every generated-artifact builder shares (Build-RootConfig, Build-GitKeep, …) —
    one living copy of the canonicalise/compare/write logic instead of one per builder (see
    docs/adr/principles/one-living-version.md). It is a pure primitive: no console output — callers own
    their reporting.
.PARAMETER Path
    Path of the target file to write.
.PARAMETER Content
    The full intended content. Canonicalised before compare and write: CR stripped, trailing newlines
    collapsed to exactly one.
.PARAMETER DryRun
    Report whether the file would change without writing it. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.OUTPUTS
    [bool] $true when the file was written (or would be, under -DryRun); $false when already current.
.EXAMPLE
    Write-FileIfChanged -Path $readmePath -Content $composed
.EXAMPLE
    Write-FileIfChanged -Path $settingsPath -Content $composed -DryRun
#>
function Write-FileIfChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyString()]
        [string] $Content,

        [switch] $DryRun
    )

    # Canonical text: LF endings, exactly one trailing newline.
    $canonical = (($Content -replace "`r", '').TrimEnd("`n")) + "`n"

    # EOL-insensitive compare against what is on disk: strip CR so a CRLF/LF flip never counts as a change.
    $existing = if ([System.IO.File]::Exists($Path)) {
        [System.IO.File]::ReadAllText($Path) -replace "`r", ''
    }
    else {
        $null
    }
    $changed = $canonical -cne $existing

    if ($changed -and -not $DryRun) {
        $directory = [System.IO.Path]::GetDirectoryName($Path)
        if ($directory) {
            [System.IO.Directory]::CreateDirectory($directory) | Out-Null
        }
        if ([System.IO.File]::Exists($Path)) {
            # Delete-then-write: an in-place write through a linked target would tunnel the composed content
            # into the link's source of truth; deleting first severs any link, so the write is always a fresh,
            # independent file.
            [System.IO.File]::Delete($Path)
        }
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Path, $canonical, $utf8NoBom)
    }

    $changed
}
