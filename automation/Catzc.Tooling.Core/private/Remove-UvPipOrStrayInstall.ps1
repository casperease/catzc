# catzc:
#   path: automation/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1
#   module: Catzc.Tooling.Core
#   visibility: private

<#
.SYNOPSIS
    Shared tail of the Unix off-config removers: evict a uv-managed-Python pip package, else delete a stray
    on-PATH binary. Both steps are user-space.
.DESCRIPTION
    Neither step needs elevation: the pip removal is uv-scoped, and the delete touches only the resolved binary.
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md#comment1)
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.PARAMETER Source
    Passed in, never looked up again, so the file deleted is exactly the one the caller judged.
    [comment:2](/docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md#comment2)
.OUTPUTS
    [bool] — $true when an off-config install was removed, $false when there was nothing to remove.
#>
function Remove-UvPipOrStrayInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config,

        [Parameter(Mandatory, Position = 1)]
        [string] $Source
    )

    # pip shadow in the uv-managed Python — the uv-scoped uninstall, never a foreign system pip.
    $pipName = if ($Config.pip_package) {
        $Config.pip_package
    }
    else {
        $Config.command
    }
    if (Test-Command uv) {
        $show = Invoke-Executable "uv pip show --system $pipName" -PassThru -NoAssert -Silent
        if ($show.Output) {
            Invoke-Executable "uv pip uninstall --system $pipName"
            return $true
        }
    }

    # A root-owned path fails the delete loudly, never a silent forced removal; only the resolved file goes.
    # [comment:3](/docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md#comment3)
    if ([System.IO.File]::Exists($Source)) {
        Write-Message "Removing stray '$($Config.command)' at '$Source'"
        [System.IO.File]::Delete($Source)
        return $true
    }

    Write-Message "Nothing off-config to remove for '$($Config.command)'"
    $false
}
