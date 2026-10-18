<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/Uninstall-Git.ps1
    name: uninstall-git
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
    test: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Git.Tests.ps1
---
#>

function Uninstall-Git {
    [CmdletBinding()]
    param()

    if ($IsWindows) {
        $installDir = Join-Path $env:LOCALAPPDATA 'Git'
        $cmdDir = Join-Path $installDir 'cmd'

        if (-not (Test-Path $installDir)) {
            Write-Message "Git is not installed at '$installDir' — nothing to do"
            return
        }

        Write-Message "Removing '$installDir'"
        Remove-Item $installDir -Recurse -Force

        Remove-PermanentPath $cmdDir

        Write-Message "Git uninstalled from '$installDir'"
    }
    elseif ($IsMacOS) {
        Assert-Command brew
        if (-not (Test-Command git)) {
            Write-Message 'Git is not installed — nothing to do'
            return
        }
        Invoke-Executable 'brew uninstall git'
        Write-Message 'Git uninstalled via brew'
    }
    elseif ($IsLinux) {
        Assert-IsAdministrator -ErrorText 'Uninstall-Git on Linux requires root (apt-get). Run as root or uninstall Git manually.'
        Assert-Command apt-get
        Invoke-Executable 'sudo apt-get remove -y git'
        Write-Message 'Git uninstalled via apt-get'
    }
    else {
        throw 'Unsupported platform for Git uninstallation'
    }
}
