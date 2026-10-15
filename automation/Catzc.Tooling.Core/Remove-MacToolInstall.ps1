<#
.SYNOPSIS
    Evicts an off-config macOS install of a tool so the managed build can win — the macOS platform core of the
    tool-removal lifecycle.
.DESCRIPTION
    The macOS counterpart to Remove-SystemInstallation (Windows) and Remove-LinuxToolInstall (Linux).
    [ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7),
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    [comment:1](/docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md#comment1)
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.OUTPUTS
    [bool] — $true when an off-config install was removed, $false when there was nothing to remove.
#>
function Remove-MacToolInstall {
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
    # [comment:2](/docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md#comment2)
    if (Test-Command brew) {
        $prefixResult = Invoke-Executable 'brew --prefix' -PassThru -NoAssert -Silent
        $prefix = if ($prefixResult.Output) {
            $prefixResult.Output.Trim()
        }
        else {
            ''
        }
        if ($prefix -and $source.StartsWith($prefix)) {
            $link = (Invoke-Executable "readlink $source" -PassThru -NoAssert -Silent).Output
            if ($link -and $link -match 'Cellar/([^/]+)/') {
                $formula = $Matches[1]
                Invoke-Executable "brew uninstall --force $formula"
                return $true
            }
        }
    }

    # 2. uv-Python pip shadow, then 3. a stray binary — the shared user-space tail (also used by Linux).
    Remove-UvPipOrStrayInstall -Config $Config -Source $source
}
