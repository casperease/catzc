<#
---
catzc:
  immutable:
    with_body_sha: "8f43b725ebe8"
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1
    docs: "[Uninstall-Dotnet.ps1.md](../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Dotnet.ps1.md)"
    cites:
      - ADR-AUTO-ONEJOB-CALLERHANDLESERRORS
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
---
#>

function Uninstall-Dotnet {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    try {
        $config = Get-ToolConfig -Tool 'dotnet'

        $installDir = Get-ScriptInstallDir -Config $config

        # Idempotent: skip if directory does not exist
        if (-not (Test-Path $installDir)) {
            Write-Message "Dotnet is not installed at '$installDir' — nothing to do"
        }
        else {
            # Everything that can refuse runs before anything is deleted, so a refusal leaves the install whole.
            $holders = @(Get-DotnetInstallHolder -InstallDir $installDir)
            if ($holders.Count -gt 0 -and -not $Force) {
                throw "Uninstall-Dotnet: '$installDir' is in use by: $(($holders | ForEach-Object { "$_" }) -join '; '). " +
                'Stop them (`dotnet build-server shutdown` stops the MSBuild and compiler servers; quit VS Code for its C# servers), ' +
                'or rerun with -Force to stop exactly these processes.'
            }
            if ($IsWindows -and (Test-IsAdministrator)) {
                throw "Uninstall-Dotnet: this shell is elevated, but '$installDir' is the managed user-space install, which needs no elevation. " +
                'A machine-scope .NET (C:\Program Files\dotnet) is removed with winget (winget list Microsoft.DotNet); ' +
                'to remove the user-space install, rerun from a non-elevated shell.'
            }
            if ($holders.Count -gt 0) {
                Stop-DotnetInstallHolder -InstallDir $installDir -Holder $holders
            }

            Write-Message "Removing '$installDir'"
            Remove-Item $installDir -Recurse -Force

            # Clean up current session + persistent PATH
            $env:DOTNET_ROOT = $null
            Remove-PermanentPath $installDir -Label 'Install-Dotnet'

            # Clean persistent DOTNET_ROOT separately
            if ($IsWindows) {
                # the seam announces the removal, and does nothing when DOTNET_ROOT is not set
                Set-PermanentEnvironmentVariable DOTNET_ROOT $null
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

            Write-Message "Dotnet uninstalled from '$installDir'; DOTNET_ROOT removed from the session and the user environment"
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
