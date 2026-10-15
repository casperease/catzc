<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: public
---
#>

<#
.SYNOPSIS
    Provisions the local development environment with all required tools.
.DESCRIPTION
    A tool at the right version but outside the expected manager is left untouched with a message, not replaced.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment1)
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

    # Chocolatey must go first because the toolset installs through winget on Windows, never through Chocolatey.
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment2)
    Uninstall-Chocolatey

    # Report tools that work but aren't managed by us — left untouched.
    $status = Get-ToolsStatus
    $usable = @($status | Where-Object { $_.Status -eq 'Usable' })
    foreach ($tool in $usable) {
        Write-Message "Skipping $($tool.Tool) — $($tool.Installed) already installed, not managed by tools system"
    }

    # Git is installed before the locked set: it is no tools.yml tool, and its Git Bash is the bash asserted below.
    # [comment:3](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment3)
    Install-Git -Force:$Force

    # Version-locked tools (from tools.yml, dependency-ordered via DependsOn)
    $skipped = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($toolName in Get-ToolInstallOrder) {
        $config = Get-ToolConfig -Tool $toolName

        # Windows-only tools (winget) do not exist on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        # A platform-provided tool is only asserted present, so the tools that depend on it fail fast if it is absent.
        # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment4)
        if ($config.system_provided) {
            Assert-True (Test-Tool $toolName -SkipVersionCheck) -ErrorText (
                "$toolName is required but is provided by the platform, not the toolchain — install it and re-run " +
                "(winget: install 'App Installer' from the Microsoft Store; bash on Windows: Install-Git). " +
                "Test-Tool $toolName -PassThru | Write-ToolProbeReport shows where it was looked for."
            )
            continue
        }

        # A non-elevated run skips and reports these tools instead of failing the whole provision; re-run elevated.
        # [comment:5](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment5)
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform. Re-run Install-DevBoxTools elevated to install it."
            $skipped.Add($toolName) | Out-Null
            continue
        }

        # A skipped dependency with no command from an earlier install blocks this tool, so it is skipped, not failed.
        # [comment:6](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment6)
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
    Install-Postman -Force:$Force
}
