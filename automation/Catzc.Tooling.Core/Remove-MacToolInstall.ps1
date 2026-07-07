<#
.SYNOPSIS
    Evicts an off-config macOS install of a tool so the managed build can win — the macOS platform core of the
    tool-removal lifecycle.
.DESCRIPTION
    The macOS counterpart to Remove-SystemInstallation (Windows) and Remove-LinuxToolInstall (Linux)
    (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:7). In precedence order:

      1. a Homebrew-owned binary -> brew uninstall <owning formula>   (user-space)
      2. a uv-managed-Python package -> uv pip uninstall --system      (user-space)
      3. a stray binary on PATH      -> delete the file                (user-space)

    The brew owner is resolved by locating the on-PATH binary under 'brew --prefix' and reading its Cellar
    symlink target for the formula name — so a brew 'azure-cli' is caught even though az_cli's configured
    manager is uv. Every macOS mechanism is user-space; nothing here asserts elevation (ADR-REMOVE:6). Steps 2
    and 3 are the shared Unix tail (Remove-UvPipOrStrayInstall), identical to Linux.

    This is invoked from the Unix branch of a Remove-<Tool>, which owns the -Force dry-run gate and the
    managed-install refusal (Test-ExpectedPackageManager) — so this core is only ever reached for an off-config
    install, and just evicts it.
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

    # 1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
    #    carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
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
