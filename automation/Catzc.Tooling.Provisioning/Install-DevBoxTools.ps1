<#
.SYNOPSIS
    Provisions the local development environment with all required tools.
.DESCRIPTION
    Installs all locked tool versions in dependency order (derived from
    DependsOn in tools.yml). Idempotent — safe to run repeatedly. Skips
    tools that are already installed at the correct version. Tools at the
    correct version but installed outside the expected manager are left
    untouched with a message.
.PARAMETER Force
    Replace existing installations that are at the wrong version.
.EXAMPLE
    Install-DevBoxTools
.EXAMPLE
    Install-DevBoxTools -Force
#>
function Install-DevBoxTools {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    # Remove Chocolatey if present — this toolset uses winget on Windows.
    # See ADR: use-proper-package-managers.
    Uninstall-Chocolatey

    # Report tools that work but aren't managed by us — left untouched.
    $status = Get-ToolsStatus
    $usable = @($status | Where-Object { $_.Status -eq 'Usable' })
    foreach ($tool in $usable) {
        Write-Message "Skipping $($tool.Tool) — $($tool.Installed) already installed, not managed by tools system"
    }

    # Version-locked tools (from tools.yml, dependency-ordered via DependsOn)
    foreach ($toolName in Get-ToolInstallOrder) {
        $config = Get-ToolConfig -Tool $toolName

        # Windows-only tools (winget) do not exist on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        # OS-provided tools (winget) are never installed — assert present (the session janitor keeps them on
        # PATH via their session_path_hints) and move on, so the tools that depend on them fail fast if absent.
        if ($config.system_provided) {
            Assert-Command $config.command -ErrorText "$toolName is required but is provided by the operating system, not the toolchain — install it and re-run (on Windows, install 'App Installer' from the Microsoft Store to get winget)."
            continue
        }

        $installCmd = "Install-$(Get-ToolCommandSuffix -Tool $toolName)"
        if (-not (Get-Command $installCmd -ErrorAction SilentlyContinue)) {
            throw "No $installCmd function found for tool '$toolName' defined in tools.yml"
        }

        if ($config.pip_package -and -not $config.script_install) {
            # Pip tools don't support -Force (version is pinned by pip ==version.*)
            & $installCmd
        }
        else {
            & $installCmd -Force:$Force
        }
    }

    # Additional tools (not version-locked, not in tools.yml)
    Install-Git -Force:$Force
    Install-Postman -Force:$Force
}
