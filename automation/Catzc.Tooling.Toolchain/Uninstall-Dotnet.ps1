<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Dotnet.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/Uninstall-Dotnet.ps1.md
      test: automation/Catzc.Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
  config:
    synopsis: Uninstalls the .NET SDK installed by Install-Dotnet.
    description: |-
      Removes the managed user-space install directory and cleans persistent environment variables (DOTNET_ROOT
      and PATH) — the managed uninstall. Idempotent — skips if the directory does not exist.

      Nothing is deleted while a process holds the install open (Get-DotnetInstallHolder — an MSBuild node, the
      compiler server, an editor's C# language server): the uninstall throws, naming each holder, so a locked file
      can never leave a half-deleted install. -Force stops exactly those named processes first. On Windows it also
      refuses to run elevated: the managed install is user-space and needs no elevation, so an elevated shell means
      the target is a machine-scope .NET (C:\Program Files\dotnet), which winget removes — never this one.

      For a .NET installed OUTSIDE the
      tooling system (a system SDK, an apt package), escalate with -Remove -Force: the managed uninstall runs
      best-effort and then falls through to Remove-Dotnet, which evicts whatever the configured manager did not
      own ([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
    parameters:
      Remove: |-
        After the managed uninstall, escalate to Remove-Dotnet to evict an off-config install. Pair with -Force to
        actually remove; -Remove alone reports the plan
        ([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
      Force: |-
        Confirm the destructive steps: stop the processes named as holding the install open, and — with -Remove —
        the Remove-Dotnet eviction.
    examples:
      - Uninstall-Dotnet
      - 'Uninstall-Dotnet -Force    # also stops the named processes holding the install open'
      - Uninstall-Dotnet -Remove -Force
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
