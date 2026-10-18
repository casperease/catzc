<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/private/Find-WindowsGitCredentialManager.ps1
    folder: private
    name: find-windows-git-credential-manager
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Provisioning/tests/Find-WindowsGitCredentialManager.Tests.ps1
---
#>

function Find-WindowsGitCredentialManager {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $candidates = @(
        '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'
        '/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe'
        '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager-core.exe'
        '/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe'
    )

    # The per-user portable install (Install-Git) lands under each Windows user's LOCALAPPDATA.
    if ([System.IO.Directory]::Exists('/mnt/c/Users')) {
        foreach ($userFolder in [System.IO.Directory]::EnumerateDirectories('/mnt/c/Users')) {
            $candidates += (Join-Path $userFolder 'AppData/Local/Git/mingw64/bin/git-credential-manager.exe')
        }
    }

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }
    $null
}
