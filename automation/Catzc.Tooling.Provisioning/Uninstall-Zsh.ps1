# catzc:
#   path: automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1
#   module: Catzc.Tooling.Provisioning
#   visibility: public

<#
.SYNOPSIS
    Uninstalls the zsh Install-Zsh placed: in Git Bash's tree on Windows, the apt-get package on Linux.
.DESCRIPTION
    Only manifest-listed files go, so a file Git's tree had before Install-Zsh stays; apt must own a Linux zsh.
    [ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2),
    [ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2),
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md#comment1)
.EXAMPLE
    Uninstall-Zsh
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

    # Reverse ordinal order puts a child before its parent; a folder that still holds another tool's file stays.
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md#comment2)
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
