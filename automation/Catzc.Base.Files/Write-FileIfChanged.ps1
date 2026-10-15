<#
.SYNOPSIS
    Writes canonical text to a file only when its content actually changed — the shared primitive behind
    every idempotent "keep this generated file current" writer.
.DESCRIPTION
    Canonicalises the given content (LF endings, exactly one trailing newline) and compares it to what is on disk,...
    [ADR-AUTO-CACHE](/docs/adr/automation/caching.md), [ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)
    [comment:1](/docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md#comment1)
.PARAMETER Path
    Path of the target file to write.
.PARAMETER Content
    The full intended content.
    [comment:2](/docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md#comment2)
.PARAMETER DryRun
    Report whether the file would change without writing it.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:3](/docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md#comment3)
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
            # Delete-then-write: an in-place write through a linked target would tunnel the composed content into the...
            # [comment:4](/docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md#comment4)
            [System.IO.File]::Delete($Path)
        }
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Path, $canonical, $utf8NoBom)
    }

    $changed
}
