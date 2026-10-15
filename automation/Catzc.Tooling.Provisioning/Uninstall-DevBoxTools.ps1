<#
.SYNOPSIS
    Removes all tools installed by Install-DevBoxTools.
.DESCRIPTION
    Dependents go first so their uninstallers can still use the dependency; winget is never removed.
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

    # The @() wrap matters: Reverse throws on null, and a one-tool result would unwrap to a scalar, not an array.
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

        # Uninstalling needs the same elevation as installing, so a non-elevated run skips and reports these tools.
        # [comment:3](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment3)
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform to uninstall. Re-run elevated."
            continue
        }

        # A raw key such as node_js never resolves to Uninstall-NodeJs, so the suffix is mapped; a missing one throws.
        # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md#comment4)
        $uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $uninstallCmd -ErrorAction SilentlyContinue)) {
            throw "No $uninstallCmd function found for tool '$toolName' defined in tools.yml"
        }
        & $uninstallCmd
    }
}
