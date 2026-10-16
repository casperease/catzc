<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.ps1
    name: uninstall-dev-box-tools
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md
      test: automation/Catzc.Tooling.Provisioning/tests/Uninstall-DevBoxTools.Tests.ps1
  config:
    synopsis: Removes all tools installed by Install-DevBoxTools.
    description: |-
      Uninstalls tools in reverse dependency order (derived from depends_on
      in tools.yml). Tools that depend on others are removed first so their
      uninstallers can still use the dependency (e.g., az_cli is removed
      before uv). OS-provided prerequisites (winget) are never uninstalled,
      and Windows-only tools are skipped off Windows. Idempotent — skips
      tools that are not installed.
    examples:
      - Uninstall-DevBoxTools
---
#>

function Uninstall-DevBoxTools {
    [CmdletBinding()]
    param()

    # Additional tools first (no dependencies on version-locked tools)
    Uninstall-Postman
    Uninstall-Git

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

        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform to uninstall. Re-run elevated."
            continue
        }

        $uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $uninstallCmd -ErrorAction SilentlyContinue)) {
            throw "No $uninstallCmd function found for tool '$toolName' defined in tools.yml"
        }
        & $uninstallCmd
    }
}
