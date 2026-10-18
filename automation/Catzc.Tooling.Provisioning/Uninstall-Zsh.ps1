<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1
    name: uninstall-zsh
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md
    test: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
    cites:
      - ADR-AUTO-IDEM#2
      - ADR-AUTO-REMOVE#{2,6}
---
#>

function Uninstall-Zsh {
    [CmdletBinding()]
    param()

    if ($IsLinux) {
        # The shared apt uninstaller: it removes the package the entry's apt_package names, only when apt owns it.
        Uninstall-Tool -Tool zsh
        return
    }

    if (-not $IsWindows) {
        Write-Message 'zsh is provided by the system, not installed by Install-Zsh — nothing to do'
        return
    }

    $layout = Get-ZshInstallLayout
    if (-not [System.IO.File]::Exists($layout.Manifest)) {
        Write-Message "zsh is not installed by Install-Zsh in '$($layout.GitHome)' — nothing to do"
        return
    }

    $manifest = [System.IO.File]::ReadAllText($layout.Manifest) | ConvertFrom-Json
    Write-Message "Removing zsh ($($manifest.Package)) from '$($layout.GitHome)'"
    foreach ($file in @($manifest.Files)) {
        $path = Join-Path $layout.GitHome $file
        if ([System.IO.File]::Exists($path)) {
            [System.IO.File]::Delete($path)
        }
    }
    [System.IO.File]::Delete($layout.Manifest)

    $directories = [System.Collections.Generic.List[string]]::new([string[]] @($manifest.Directories))
    $directories.Sort([System.StringComparer]::Ordinal)
    $directories.Reverse()
    foreach ($directory in $directories) {
        $path = Join-Path $layout.GitHome $directory
        if ([System.IO.Directory]::Exists($path) -and [System.IO.Directory]::GetFileSystemEntries($path).Length -eq 0) {
            [System.IO.Directory]::Delete($path)
        }
    }

    Write-Message "zsh uninstalled from '$($layout.GitHome)'"
}
