<#
---
catzc:
  immutable:
    with_body_sha: ffc333bd0426
---
#>

function Resolve-ListenSession {
    <#
    .SYNOPSIS
        Resolves a listen session's folder: the one named, or the newest under the output folder.

    .DESCRIPTION
        A session folder is named by its start stamp (yyyyMMdd-HHmmss), so the newest is the last by ordinal name. A session must hold
        its seen.json index; a folder without one is no session. The output folder lives in out/, which can be wiped at any time, so a
        session can be missing at the start and can vanish while it is in use.

    .PARAMETER Session
        The session folder. Omitted: the newest session under listen.yml's output folder.

    .PARAMETER AllowMissing
        Return nothing, instead of throwing, when there is no such session.
    #>
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
            $sessions = @([System.IO.Directory]::GetDirectories($output) | Where-Object { [System.IO.File]::Exists((Join-Path $_ 'seen.json')) })
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
