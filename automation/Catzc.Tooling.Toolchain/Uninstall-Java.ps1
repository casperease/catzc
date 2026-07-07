<#
.SYNOPSIS
    Uninstalls Java via the platform package manager.
.DESCRIPTION
    Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from
    $PROFILE) — the managed uninstall. For a Java installed OUTSIDE the tooling system (a foreign JDK, an apt
    package on a uv-first box), escalate with -Remove -Force: the managed uninstall runs best-effort and then
    falls through to Remove-Java, which evicts whatever the configured manager did not own
    (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:5).
.PARAMETER Version
    Java version to uninstall. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-Java to evict an off-config install. Pair with -Force to
    actually remove; -Remove alone reports the plan (ADR-REMOVE:4).
.PARAMETER Force
    Confirm the destructive Remove-Java step of the escalation. Ignored without -Remove.
.EXAMPLE
    Uninstall-Java
.EXAMPLE
    Uninstall-Java -Remove -Force
#>
function Uninstall-Java {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    # Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
    # -Remove it propagates (ADR-ERROR:6, ADR-REMOVE:5).
    try {
        Uninstall-Tool -Tool 'java' -Version $Version

        # Clean up JAVA_HOME
        $env:JAVA_HOME = $null

        if ($IsWindows) {
            [Environment]::SetEnvironmentVariable('JAVA_HOME', $null, 'User')
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
