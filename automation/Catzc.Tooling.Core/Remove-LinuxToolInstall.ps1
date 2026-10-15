<#
.SYNOPSIS
    Evicts an off-config Linux install of a tool so the managed (user-space) build can win — the Linux
    counterpart to Remove-SystemInstallation (Windows).
.DESCRIPTION
    Given a tool's tools.yml config, removes an install that did NOT come from the tool's configured manager — the...
    [ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7),
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    [comment:1](/docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md#comment1)
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.OUTPUTS
    [bool] — $true when an off-config install was removed, $false when there was nothing to remove.
#>
function Remove-LinuxToolInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not (Test-Command $Config.command)) {
        Write-Message "No '$($Config.command)' on PATH — nothing to remove"
        return $false
    }

    $source = (Get-Command $Config.command).Source

    # 1.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md#comment2)
    if (Test-Command dpkg) {
        $owner = Invoke-Executable "dpkg -S $source" -PassThru -NoAssert -Silent
        if ($owner.ExitCode -eq 0 -and $owner.Output) {
            $package = ($owner.Output -split ':', 2)[0].Trim()
            Assert-IsAdministrator -ErrorText "Removing the apt package '$package' (it owns '$source') needs root. Re-run elevated, or run 'sudo apt-get remove -y $package' by hand."
            Invoke-Executable "sudo apt-get remove -y $package"
            return $true
        }
    }

    # 2. uv-Python pip shadow, then 3. a stray binary — the shared user-space tail (also used by macOS).
    Remove-UvPipOrStrayInstall -Config $Config -Source $source
}
