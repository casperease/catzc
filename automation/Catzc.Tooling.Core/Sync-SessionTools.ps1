<#
.SYNOPSIS
    Reconciles the current session's PATH to the tools that are actually present, and reports any running from
    outside the installer layer. Registered as a post-import janitor.
.DESCRIPTION
    A lightweight, quiet-on-clean pass over the tools.yml set.
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

    # Session PATH nudging is noise — and could shadow image-provided tools — in CI, where the pipeline owns tool...
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
        # When several installs exist, run the best one (tools.yml session_host_probes — for dotnet an SDK at the...
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
        # The fact and WHICH tools is the advisory — it stays on the always-on information stream.
        # [comment:4](/docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md#comment4)
        Write-Message "Session tools not managed by the installer layer: $($foreignNames -join '; ')"
        Write-Message "Locations: $($foreignLocations -join '; ')" -Verbose:($VerbosePreference -eq 'Continue')
    }
}
