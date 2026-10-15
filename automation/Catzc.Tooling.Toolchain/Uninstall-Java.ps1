<#
.SYNOPSIS
    Uninstalls Java via the platform package manager.
.DESCRIPTION
    Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from...
    [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md#comment1)
.PARAMETER Version
    Java version to uninstall. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-Java to evict an off-config install.
    [ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)
    [comment:2](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md#comment2)
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

    # Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without -Remove it...
    # [ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
    # [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md#comment3)
    try {
        Uninstall-Tool -Tool 'java' -Version $Version

        # Clean up JAVA_HOME.
        # [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)
        # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md#comment4)
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
