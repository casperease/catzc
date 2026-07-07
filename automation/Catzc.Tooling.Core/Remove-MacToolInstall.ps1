<#
.SYNOPSIS
    Evicts an off-config macOS install of a tool — the macOS platform core of the tool-removal lifecycle.
    NOT IMPLEMENTED YET (stub).
.DESCRIPTION
    The macOS counterpart to Remove-SystemInstallation (Windows) and Remove-LinuxToolInstall (Linux)
    (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:7). macOS off-config eviction — routing a
    Homebrew-owned shadow through 'brew uninstall', or deleting a stray binary — is not built yet. This stub
    throws so a macOS removal fails honestly and points at the manual path, rather than silently falling
    through to another platform's core. Filling it in is the macOS half of "our case is Linux + Windows".
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.OUTPUTS
    [bool] — once implemented, $true when an off-config install was removed.
#>
function Remove-MacToolInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-False $true -ErrorText "Remove-MacToolInstall is not implemented yet — off-config eviction on macOS is pending (ADR-REMOVE:7). Uninstall '$($Config.command)' with 'brew uninstall', or remove the stray binary by hand."
}
