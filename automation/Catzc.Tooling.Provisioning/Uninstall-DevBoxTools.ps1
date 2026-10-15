<#
.SYNOPSIS
    Removes all tools installed by Install-DevBoxTools.
.DESCRIPTION
    Uninstalls tools in reverse dependency order (derived from depends_on in tools.yml).
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment1)
.EXAMPLE
    Uninstall-DevBoxTools
#>
function Uninstall-DevBoxTools {
    [CmdletBinding()]
    param()

    # Additional tools first (no dependencies on version-locked tools)
    Uninstall-Postman
    Uninstall-Git

    # Version-locked tools in reverse dependency order.
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment2)
    $order = @(Get-ToolInstallOrder)
    [array]::Reverse($order)

    foreach ($toolName in $order) {
        $config = Get-ToolConfig -Tool $toolName

        # Windows-only tools (winget) do not exist on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        # OS-provided tools (winget) are supplied by the OS — the toolchain never uninstalls them.
        if ($config.system_provided) {
            continue
        }

        # Elevation-bound tools (admin_only machine-scope, or apt-get-routed Linux installs) need the same elevation...
        # [comment:3](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment3)
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform to uninstall. Re-run elevated."
            continue
        }

        # Map the snake_case tools.yml key to its PascalCase command suffix, exactly as Install-DevBoxTools does...
        # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment4)
        $uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $uninstallCmd -ErrorAction SilentlyContinue)) {
            throw "No $uninstallCmd function found for tool '$toolName' defined in tools.yml"
        }
        & $uninstallCmd
    }
}
