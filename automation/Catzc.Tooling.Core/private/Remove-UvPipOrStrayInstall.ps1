<#
.SYNOPSIS
    Shared tail of the Unix off-config removers: evict a uv-managed-Python pip package, else delete a stray
    on-PATH binary. Both steps are user-space.
.DESCRIPTION
    Called by Remove-LinuxToolInstall and Remove-MacToolInstall after each has tried its native package
    manager (apt on Linux, brew on macOS). Neither step here needs elevation (ADR-AUTO-REMOVE:6): the pip removal is
    the uv-scoped 'uv pip uninstall --system' (never a foreign system pip), and the stray delete removes only
    the resolved binary. Private to Catzc.Tooling.Core.
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.PARAMETER Source
    The resolved path of the tool's on-PATH binary (from Get-Command) — the caller resolves it once and passes
    it in.
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

    # Stray binary no manager owns — delete just the resolved file (a root-owned path fails the delete loudly
    # rather than being force-removed silently).
    if ([System.IO.File]::Exists($Source)) {
        Write-Message "Removing stray '$($Config.command)' at '$Source'"
        [System.IO.File]::Delete($Source)
        return $true
    }

    Write-Message "Nothing off-config to remove for '$($Config.command)'"
    $false
}
