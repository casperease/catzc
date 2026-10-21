<#
---
catzc:
  immutable:
    with_body_sha: c0103d658cb9
  edges:
    test: pwsh/Catzc.Base.Files/tests/Write-FileIfChanged.Tests.ps1
    docs: "[Write-FileIfChanged.ps1.md](docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-DRYRUN
      - ADR-PRIN-ONELIVE
---
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
            [System.IO.File]::Delete($Path)
        }
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($Path, $canonical, $utf8NoBom)
    }

    $changed
}
