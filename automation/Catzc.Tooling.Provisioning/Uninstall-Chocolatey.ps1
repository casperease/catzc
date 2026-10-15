<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
    kind: public-function
    module: Catzc.Tooling.Provisioning
    visibility: public
    adrs:
      - ADR-AUTO-TEST#33
  config:
    synopsis: Uninstalls Chocolatey from the current machine.
    description: |-
      Removes the Chocolatey package manager if it is installed.
      Idempotent — safe to run when Chocolatey is not present.
      Windows-only; returns immediately on other platforms.
    examples:
      - Uninstall-Chocolatey
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
    # Remove environment variable the seam announces each removal, and does nothing in a scope where the variable is...
    # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md#comment4)
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine
    Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope User

    # Remove Chocolatey from PATH — through the PATH seams, which announce the change
    # [comment:5](/docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md#comment5)
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
