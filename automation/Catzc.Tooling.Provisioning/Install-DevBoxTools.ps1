<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1
    kind: automation-function
    module: Catzc.Tooling.Provisioning
    visibility: public
  config:
    synopsis: Provisions the local development environment with all required tools.
    description: |-
      Installs all locked tool versions in dependency order (derived from
      DependsOn in tools.yml). Idempotent — safe to run repeatedly. Skips
      tools that are already installed at the correct version. Tools at the
      correct version but installed outside the expected manager are left
      untouched with a message.
    parameters:
      Force: Replace existing installations that are at the wrong version.
    examples:
      - Install-DevBoxTools
      - Install-DevBoxTools -Force
---
#>

function Install-DevBoxTools {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    # Remove Chocolatey if present — this toolset uses winget on Windows.
    # [comment:7](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment7)
    Uninstall-Chocolatey

    # Report tools that work but aren't managed by us — left untouched.
    $status = Get-ToolsStatus
    $usable = @($status | Where-Object { $_.Status -eq 'Usable' })
    foreach ($tool in $usable) {
        Write-Message "Skipping $($tool.Tool) — $($tool.Installed) already installed, not managed by tools system"
    }

    # Git first: a base tool (not version-locked, not in tools.yml) that the locked set builds on — on Windows its...
    # [comment:8](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment8)
    Install-Git -Force:$Force

    # Version-locked tools (from tools.yml, dependency-ordered via DependsOn)
    $skipped = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($toolName in Get-ToolInstallOrder) {
        $config = Get-ToolConfig -Tool $toolName

        # Windows-only tools (winget) do not exist on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        # Platform-provided tools (winget; bash — the OS's, or Git Bash on Windows) are never installed — assert...
        # [comment:9](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment9)
        if ($config.system_provided) {
            Assert-True (Test-Tool $toolName -SkipVersionCheck) -ErrorText (
                "$toolName is required but is provided by the platform, not the toolchain — install it and re-run " +
                "(winget: install 'App Installer' from the Microsoft Store; bash on Windows: Install-Git). " +
                "Test-Tool $toolName -PassThru | Write-ToolProbeReport shows where it was looked for."
            )
            continue
        }

        # Elevation-bound tools (admin_only machine-scope installers, or apt-get-routed Linux installs —...
        # [comment:10](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment10)
        if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {
            Write-Message "Skipping $toolName — requires elevation on this platform. Re-run Install-DevBoxTools elevated to install it."
            $skipped.Add($toolName) | Out-Null
            continue
        }

        # A tool whose declared dependency was skipped this run — and whose dependency's command is not available...
        # [comment:11](/docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md#comment11)
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
