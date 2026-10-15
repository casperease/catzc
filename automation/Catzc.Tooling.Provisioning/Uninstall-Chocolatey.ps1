<#
.SYNOPSIS
    Uninstalls Chocolatey from the current machine.
.DESCRIPTION
    Safe to run when Chocolatey is absent, and it returns at once on any platform but Windows.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md#comment1)
.EXAMPLE
    Uninstall-Chocolatey
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
    # Both scopes are cleared: the seam does nothing where the variable is unset, so no scope check is needed.
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md#comment2)
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope User

    # PATH changes go through the PATH seams, never straight to the registry, so each change is announced.
    # [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)
    # [comment:3](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md#comment3)
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
