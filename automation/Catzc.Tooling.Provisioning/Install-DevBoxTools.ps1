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
    $skipped = [System.Collections.Generic.HashSet[string]]::new()
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

        # Elevation-bound tools (admin_only machine-scope installers, or apt-get-routed Linux installs —
        # Test-ToolRequiresElevation) cannot install without elevation. Skip and report in a non-elevated run
        # rather than failing the whole provision; re-run elevated to get them.
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform. Re-run Install-DevBoxTools elevated to install it."
            $skipped.Add($toolName) | Out-Null
            continue
        }

        # A tool whose declared dependency was skipped this run — and whose dependency's command is not
        # available from an earlier install either — cannot install. Skip and report it with the same
        # remediation instead of letting its installer fail the whole provision.
        if ($config.depends_on -and $skipped.Contains([string] $config.depends_on)) {
            $dependencyCommand = (Get-ToolConfig -Tool $config.depends_on).command
            if (-not (Test-Command $dependencyCommand)) {
                Write-Message "Skipping $toolName — its dependency '$($config.depends_on)' was skipped and '$dependencyCommand' is not available. Re-run Install-DevBoxTools elevated to install both."
                $skipped.Add($toolName) | Out-Null
                continue
            }
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
