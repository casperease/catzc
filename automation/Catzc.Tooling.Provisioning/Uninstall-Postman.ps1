<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/Uninstall-Postman.ps1
    name: uninstall-postman
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
    test: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Postman.Tests.ps1
---
#>

function Uninstall-Postman {
    [CmdletBinding()]
    param()

    if ($IsWindows) {
        $installDir = Join-Path $env:LOCALAPPDATA 'Postman'

        if (-not (Test-Path $installDir)) {
            Write-Message "Postman is not installed at '$installDir' — nothing to do"
            return
        }

        # Squirrel apps have Update.exe --uninstall for clean removal
        $updateExe = Join-Path $installDir 'Update.exe'
        if (Test-Path $updateExe) {
            Write-Message 'Running Postman uninstaller'
            Invoke-Executable "$updateExe --uninstall" -NoAssert
        }

        # Remove any remnants the uninstaller left behind
        if (Test-Path $installDir) {
            Remove-Item $installDir -Recurse -Force
        }

        Write-Message "Postman uninstalled from '$installDir'"
    }
    elseif ($IsMacOS) {
        Assert-Command brew
        $brewCheck = Invoke-Executable 'brew list --cask postman' -PassThru -NoAssert -Silent
        if ($brewCheck.ExitCode -ne 0) {
            Write-Message 'Postman is not installed via brew — nothing to do'
            return
        }
        Invoke-Executable 'brew uninstall --cask postman'
        Write-Message 'Postman uninstalled via brew'
    }
    elseif ($IsLinux) {
        $installDir = Join-Path $HOME '.local/Postman'

        if (-not (Test-Path $installDir)) {
            Write-Message "Postman is not installed at '$installDir' — nothing to do"
            return
        }

        Remove-Item $installDir -Recurse -Force
        Write-Message "Postman uninstalled from '$installDir'"
    }
    else {
        throw 'Unsupported platform for Postman uninstallation'
    }
}
