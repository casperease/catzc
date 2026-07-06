<#
.SYNOPSIS
    Locates the Windows Git Credential Manager from inside a WSL session.
.DESCRIPTION
    Probes the known Windows-side install locations under /mnt/c — the system-wide Git for Windows
    install, and the per-user portable install Install-Git produces under LOCALAPPDATA — for the
    credential-manager executable (git-credential-manager.exe; the -core suffix on older Git for
    Windows releases). Returns the first existing path, or $null when none exists (git is not
    installed on the Windows side).
.OUTPUTS
    [string] The Windows-side executable path as WSL sees it, or $null.
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
