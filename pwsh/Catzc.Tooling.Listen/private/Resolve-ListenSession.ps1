<#
---
catzc:
  immutable:
    with_body_sha: "38c900d707da"
  edges:
    docs: "[Resolve-ListenSession.ps1.md](../../../docs/references/pwsh/catzc-tooling-listen/private/Resolve-ListenSession.ps1.md)"
---
#>

function Resolve-ListenSession {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $Session,

        [switch] $AllowMissing
    )

    if (-not $Session) {
        $output = Join-Path (Get-RepositoryRoot) (Get-Config -Config listen).output
        [string[]] $sessions = @()
        if ([System.IO.Directory]::Exists($output)) {
            $sessions = @(Get-ChildPath $output -Depth 1 -Directory | Where-Object { [System.IO.File]::Exists((Join-Path $_ 'seen.json')) })
        }
        if ($sessions.Count -eq 0) {
            Assert-True ([bool] $AllowMissing) -ErrorText "No listen session under '$output'; start one with Start-DocListener."
            return
        }
        [Array]::Sort($sessions, [System.StringComparer]::Ordinal)
        $Session = $sessions[-1]
    }

    $full = [System.IO.Path]::GetFullPath($Session)
    if (-not [System.IO.File]::Exists((Join-Path $full 'seen.json'))) {
        Assert-True ([bool] $AllowMissing) -ErrorText "'$full' is no listen session: it holds no seen.json (out/ may have been wiped)."
        return
    }
    $full
}
