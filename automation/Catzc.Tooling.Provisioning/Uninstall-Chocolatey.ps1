<#
.SYNOPSIS
    Uninstalls Chocolatey from the current machine.
.DESCRIPTION
    Removes the Chocolatey package manager if it is installed.
    Idempotent — safe to run when Chocolatey is not present.
    Windows-only; returns immediately on other platforms.
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
    # Remove environment variable
    # the seam announces each removal, and does nothing in a scope where the variable is not set
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope User

    # Remove Chocolatey from PATH — through the PATH seams, which announce the change
    # ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33))
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
