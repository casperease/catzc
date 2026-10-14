<#
.SYNOPSIS
    Uninstalls the zsh Install-Zsh placed in Git Bash's tree.
.DESCRIPTION
    Windows: reads the manifest Install-Zsh wrote inside the Git for Windows tree (LOCALAPPDATA\Git) and deletes exactly
    the files it lists, then the folders it lists once they are empty, then the manifest. A file Git's tree had before
    Install-Zsh ran is never in the manifest, so it stays
    ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)). No admin required.

    macOS and Linux: zsh is the system's, and Install-Zsh installed nothing, so there is nothing to uninstall.

    Idempotent ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)): without a
    manifest it reports that there is nothing to do, and a listed file already gone is skipped.
.EXAMPLE
    Uninstall-Zsh
#>
function Uninstall-Zsh {
    [CmdletBinding()]
    param()

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

    # Children before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest first. A
    # folder that still holds anything (a file another tool put there) stays.
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
