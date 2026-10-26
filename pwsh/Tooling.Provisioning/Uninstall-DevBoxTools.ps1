function Uninstall-DevBoxTools {
    [CmdletBinding()]
    param()

    # Additional tools first (no dependencies on version-locked tools)
    Uninstall-Postman
    Uninstall-Git

    # The @() keeps a single or null result an array, which [array]::Reverse needs.
    $order = @(Get-ToolInstallOrder)
    [array]::Reverse($order)

    foreach ($toolName in $order) {
        $config = Get-ToolConfig -Tool $toolName

        # Windows-only tools (winget) do not exist on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        # A tool another tool's installer installs alongside itself has no installer of its own.
        if ($config.PSObject.Properties['installed_by'] -and $config.installed_by) {
            continue
        }

        # OS-provided tools (winget) are supplied by the OS — the toolchain never uninstalls them.
        if ($config.system_provided) {
            continue
        }

        # A tool that needed elevation to install needs it to uninstall; skip and report when not elevated.
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform to uninstall. Re-run elevated."
            continue
        }

        # The raw snake_case key resolves only for one-word tools (node_js never reaches Uninstall-NodeJs), so map it.
        $uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $uninstallCmd -ErrorAction SilentlyContinue)) {
            throw "No $uninstallCmd function found for tool '$toolName' defined in tools.yml"
        }
        & $uninstallCmd
    }
}
