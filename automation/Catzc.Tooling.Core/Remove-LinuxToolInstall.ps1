<#
.SYNOPSIS
    Evicts an off-config Linux install of a tool so the managed (user-space) build can win — the Linux
    counterpart to Remove-SystemInstallation (Windows).
.DESCRIPTION
    Given a tool's tools.yml config, removes an install that did NOT come from the tool's configured manager
    — the shadow that would otherwise take precedence over the managed build — by the mechanism that placed
    it (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:7). In precedence order:

      1. an apt-owned binary   -> sudo apt-get remove -y <owning package>   (the one step that needs root)
      2. a uv-managed-Python package -> uv pip uninstall --system <name>    (user-space, uv-scoped)
      3. a stray binary on PATH      -> delete the file                     (user-space)

    The apt owner is resolved by 'dpkg -S <path>' (which package owns the resolved binary), so an apt
    'azure-cli' is caught even though az_cli's configured manager is uv — detection does not rely on the
    config naming an apt_package. Only the apt path asserts root; the uv-pip and stray-binary paths are
    user-space (ADR-REMOVE:6).

    This is invoked from the Linux branch of a Remove-<Tool>, which owns the -Force dry-run gate and the
    managed-install refusal (Test-ExpectedPackageManager) — so this core is only ever reached for an
    off-config install, and just evicts it.
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

    # 1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
    #    own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
    if (Test-Command dpkg) {
        $owner = Invoke-Executable "dpkg -S $source" -PassThru -NoAssert -Silent
        if ($owner.ExitCode -eq 0 -and $owner.Output) {
            $package = ($owner.Output -split ':', 2)[0].Trim()
            Assert-IsAdministrator -ErrorText "Removing the apt package '$package' (it owns '$source') needs root. Re-run elevated, or run 'sudo apt-get remove -y $package' by hand."
            Invoke-Executable "sudo apt-get remove -y $package"
            return $true
        }
    }

    # 2. pip shadow in the uv-managed Python — the uv-scoped uninstall (user-space), never a foreign system pip.
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

    # 3. Stray binary no manager owns — delete just that file (user-space; a root-owned path fails the delete
    #    loudly rather than being force-removed silently).
    if ([System.IO.File]::Exists($source)) {
        Write-Message "Removing stray '$($Config.command)' at '$source'"
        [System.IO.File]::Delete($source)
        return $true
    }

    Write-Message "Nothing off-config to remove for '$($Config.command)'"
    $false
}
