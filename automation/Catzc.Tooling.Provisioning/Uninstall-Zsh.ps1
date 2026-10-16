<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md
      test: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
    adrs:
      - ADR-AUTO-IDEM#2
      - ADR-AUTO-REMOVE#{2,6}
  config:
    synopsis: 'Uninstalls the zsh Install-Zsh placed: in Git Bash''s tree on Windows, the apt-get package on Linux.'
    description: |-
      Windows: reads the manifest Install-Zsh wrote inside the Git for Windows tree (the zsh entry's windows_install_dir,
      which Get-ScriptInstallDir resolves) and deletes exactly the files it lists, then the folders it lists once they
      are empty, then the manifest. A file Git's tree had before Install-Zsh ran is never in the manifest, so it stays
      ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)). No admin required.

      Linux: removes the package the entry's apt_package names through Uninstall-Tool (apt-get), the manager Install-Zsh
      installs it through ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)).
      A zsh that apt does not own stops the uninstall rather than being removed; the apt step needs root
      ([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

      macOS: zsh is the system's /bin/zsh, and Install-Zsh installed nothing, so there is nothing to uninstall.

      Idempotent ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)): without a
      manifest (Windows) or without zsh (Linux) it reports that there is nothing to do, and a listed file already gone is
      skipped.
    examples:
      - Uninstall-Zsh
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
