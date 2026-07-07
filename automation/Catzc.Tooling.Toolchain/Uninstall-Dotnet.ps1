<#
.SYNOPSIS
    Uninstalls the .NET SDK installed by Install-Dotnet.
.DESCRIPTION
    Removes the ~/.dotnet directory and cleans persistent environment variables (DOTNET_ROOT and PATH) — the
    managed uninstall. Idempotent — skips if the directory does not exist. For a .NET installed OUTSIDE the
    tooling system (a system SDK, an apt package), escalate with -Remove -Force: the managed uninstall runs
    best-effort and then falls through to Remove-Dotnet, which evicts whatever the configured manager did not
    own (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:5).
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-Dotnet to evict an off-config install. Pair with -Force to
    actually remove; -Remove alone reports the plan (ADR-REMOVE:4).
.PARAMETER Force
    Confirm the destructive Remove-Dotnet step of the escalation. Ignored without -Remove.
.EXAMPLE
    Uninstall-Dotnet
.EXAMPLE
    Uninstall-Dotnet -Remove -Force
#>
function Uninstall-Dotnet {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    # Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
    # -Remove it propagates (ADR-ERROR:6, ADR-REMOVE:5).
    try {
        $config = Get-ToolConfig -Tool 'dotnet'

        $installDir = Get-ScriptInstallDir -Config $config

        # Idempotent: skip if directory does not exist
        if (-not (Test-Path $installDir)) {
            Write-Message "Dotnet is not installed at '$installDir' — nothing to do"
        }
        else {
            Write-Message "Removing '$installDir'"
            Remove-Item $installDir -Recurse -Force

            # Clean up current session + persistent PATH
            $env:DOTNET_ROOT = $null
            Remove-PermanentPath $installDir -Label 'Install-Dotnet'

            # Clean persistent DOTNET_ROOT separately
            if ($IsWindows) {
                [Environment]::SetEnvironmentVariable('DOTNET_ROOT', $null, 'User')
            }
            else {
                $profilePath = $PROFILE.CurrentUserCurrentHost
                if (Test-Path $profilePath) {
                    $content = Get-Content $profilePath -Raw
                    $startMarker = '>>> catzc DOTNET_ROOT >>>'
                    $endMarker = '<<< catzc DOTNET_ROOT <<<'
                    $cleaned = $content -replace "(?s)\r?\n?# $([regex]::Escape($startMarker)).*?# $([regex]::Escape($endMarker))\r?\n?", ''
                    if ($cleaned -ne $content) {
                        Set-Content -Path $profilePath -Value $cleaned -NoNewline
                    }
                }
            }

            Write-Message "Dotnet uninstalled from '$installDir'"
        }
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-Dotnet."
    }

    if ($Remove) {
        Remove-Dotnet -Force:$Force
    }
}
