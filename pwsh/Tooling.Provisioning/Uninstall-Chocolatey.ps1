<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md"
  header: "generated"
---
#>

function Uninstall-Chocolatey {
    [CmdletBinding()]
    param()

    if (-not $IsWindows) {
        Write-Verbose 'Chocolatey is Windows-only, nothing to do'
        return
    }

    if (-not (Test-Command choco)) {
        Write-Verbose 'Chocolatey is not installed'
        return
    }

    Assert-IsAdministrator 'Uninstall-Chocolatey requires Administrator privileges'

    $chocoDir = if ($env:ChocolateyInstall) {
        $env:ChocolateyInstall
    }
    else {
        Join-Path -Path $env:SystemDrive -ChildPath 'ProgramData' -AdditionalChildPath 'chocolatey'
    }

    Assert-PathExist $chocoDir

    # Remove Chocolatey directory
    Write-Verbose "Removing Chocolatey directory: $chocoDir"
    Remove-Item $chocoDir -Recurse -Force
    # The seam announces each removal and does nothing in a scope where the variable is unset.
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope User

    # PATH goes through the PATH seams, which announce the change.
    foreach ($scope in 'Machine', 'User') {
        $path = Get-EnvironmentPath -Scope $scope
        if (-not $path) {
            continue
        }
        $cleaned = ($path -split ';' | Where-Object { $_ -notmatch 'chocolatey' }) -join ';'
        if ($cleaned -ne $path) {
            Set-EnvironmentPath $cleaned -Scope $scope
        }
    }

    Write-Message 'Chocolatey uninstalled'
}
