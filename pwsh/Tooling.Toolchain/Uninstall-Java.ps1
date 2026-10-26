function Uninstall-Java {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    # Best-effort only under -Remove, where a failure is logged and the escalation proceeds; otherwise it propagates.
    try {
        Uninstall-Tool -Tool 'java' -Version $Version

        # The removal is announced only when there was something to remove.
        if ($env:JAVA_HOME) {
            $env:JAVA_HOME = $null
            Write-Message 'Session: removed JAVA_HOME'
        }

        if ($IsWindows) {
            # the seam announces the removal, and does nothing when JAVA_HOME is not set
            Set-PermanentEnvironmentVariable JAVA_HOME $null
        }
        else {
            $marker = '>>> catzc Install-Java >>>'
            $endMarker = '<<< catzc Install-Java <<<'
            $profilePath = $PROFILE.CurrentUserCurrentHost

            if (Test-Path $profilePath) {
                $content = Get-Content $profilePath -Raw
                if ($content -match [regex]::Escape($marker)) {
                    $pattern = "(?ms)\r?\n# $([regex]::Escape($marker)).*?# $([regex]::Escape($endMarker))\r?\n?"
                    $cleaned = $content -replace $pattern, ''
                    Set-Content -Path $profilePath -Value $cleaned -NoNewline
                    Write-Message "Profile '$profilePath': removed the JAVA_HOME block"
                }
            }
        }
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-Java."
    }

    if ($Remove) {
        Remove-Java -Force:$Force
    }
}
