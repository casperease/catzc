# catzc:
#   path: automation/Catzc.Tooling.Core/Sync-SessionTools.ps1
#   module: Catzc.Tooling.Core
#   visibility: public

<#
.SYNOPSIS
    Reconciles the current session's PATH to the tools that are actually present, and reports any running from
    outside the installer layer. Registered as a post-import janitor.
.DESCRIPTION
    Session-only and advisory: it never writes the registry and prints nothing when every tool is installer-owned.
    [comment:1](/docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md#comment1)
.PARAMETER Silent
    Suppress both advisory lines outright (even under -Verbose).
.EXAMPLE
    Sync-SessionTools
#>
function Sync-SessionTools {
    [CmdletBinding()]
    param(
        [switch] $Silent
    )

    # In CI the pipeline owns tool provisioning, and PATH nudging there could shadow the tools its image provides.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md#comment2)
    if (Test-IsRunningInPipeline) {
        return
    }

    # Recover tools whose PATH entry was dropped but whose install is still registry-known and on disk.
    Sync-SessionPath

    $allTools = Get-Config -Config tools
    $foreignNames = [System.Collections.Generic.List[string]]::new()
    $foreignLocations = [System.Collections.Generic.List[string]]::new()

    foreach ($toolName in $allTools.Keys) {
        $config = Get-ToolConfig -Tool $toolName

        $cmd = Get-Command $config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        # With several installs the best one runs: for dotnet an SDK at the locked version, else a runtime at it.
        # [comment:3](/docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md#comment3)
        $hosted = Resolve-SessionToolHost -Config $config
        if ($hosted) {
            $cmd = $hosted
        }
        if (-not $cmd) {
            # Not on PATH — try the declared hints to point this session at a known install.
            $cmd = Resolve-SessionToolHint -Config $config
        }
        if (-not $cmd) {
            continue   # genuinely missing — Install-*/Get-ToolsStatus own that story, not the janitor
        }

        if (-not (Test-ToolLocationManaged -Config $config -Location $cmd.Source)) {
            $foreignNames.Add($toolName)
            $foreignLocations.Add("$toolName ($($cmd.Source))")
        }
    }

    if (-not $Silent -and $foreignNames.Count -gt 0) {
        # Names stay on the always-on stream, while locations are diagnostic detail shown only under verbose.
        # [comment:4](/docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md#comment4)
        Write-Message "Session tools not managed by the installer layer: $($foreignNames -join '; ')"
        Write-Message "Locations: $($foreignLocations -join '; ')" -Verbose:($VerbosePreference -eq 'Continue')
    }
}
