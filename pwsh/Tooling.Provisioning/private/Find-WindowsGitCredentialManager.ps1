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
