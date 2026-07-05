<#
.SYNOPSIS
    Removes all tools installed by Install-DevBoxTools.
.DESCRIPTION
    Uninstalls tools in reverse dependency order (derived from DependsOn
    in tools.yml). Tools that depend on others are removed first so their
    uninstallers can still use the dependency (e.g., pip tools need Python).
    Idempotent — skips tools that are not installed.
.EXAMPLE
    Uninstall-DevBoxTools
#>
function Uninstall-DevBoxTools {
    [CmdletBinding()]
    param()

    # Additional tools first (no dependencies on version-locked tools)
    Uninstall-Postman
    Uninstall-Git

    # Version-locked tools in reverse dependency order. @() guards the empty/null case: [array]::Reverse
    # throws on $null, and a single-element result would otherwise unwrap to a scalar (not an array).
    $order = @(Get-ToolInstallOrder)
    [array]::Reverse($order)

    foreach ($toolName in $order) {
        # Map the snake_case tools.yml key to its PascalCase command suffix, exactly as Install-DevBoxTools does
        # (node_js -> Uninstall-NodeJs, az_cli -> Uninstall-AzCli, py_spark -> Uninstall-PySpark). Building
        # "Uninstall-$toolName" from the raw key only works for single-word tools by PowerShell's case-insensitive
        # command resolution; a multi-word key ("node_js") never resolves to its function ("Uninstall-NodeJs") and
        # was silently skipped. Throw on a missing uninstaller, mirroring Install-DevBoxTools — a locked tool must
        # have one, so its absence is a defect to surface, not a tool to skip.
        $uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $uninstallCmd -ErrorAction SilentlyContinue)) {
            throw "No $uninstallCmd function found for tool '$toolName' defined in tools.yml"
        }
        & $uninstallCmd
    }
}
