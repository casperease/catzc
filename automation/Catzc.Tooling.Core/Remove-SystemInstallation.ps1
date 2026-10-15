<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs:
      - ADR-AUTO-TEST#33
---
#>

<#
.SYNOPSIS
    Removes an installation directory and cleans it from system PATH.
.DESCRIPTION
    Every persistent write goes through its seam, which announces it, so a change to the Machine PATH is never silent.
.PARAMETER InstallDir
    Resolved absolute path to the installation directory.
.PARAMETER ExtraPathDirs
    Sub-folders such as Scripts or wbin leave the Machine PATH too, not only the install directory itself.
.PARAMETER EnvironmentVariables
    System-level environment variable names to clear.
.OUTPUTS
    [bool] Whether the system PATH changed.
#>
function Remove-SystemInstallation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $InstallDir,

        [string[]] $ExtraPathDirs = @(),

        [string[]] $EnvironmentVariables = @()
    )

    if (-not $IsWindows) {
        throw 'Remove-SystemInstallation is only supported on Windows (it edits the HKLM system PATH).'
    }

    # Delete the directory
    Remove-Item -Path $InstallDir -Recurse -Force

    # Build list of paths to remove from system PATH
    $removePaths = @($InstallDir)
    foreach ($subdirectory in $ExtraPathDirs) {
        $removePaths += Join-Path $InstallDir $subdirectory
    }

    $entries = @((Get-EnvironmentPath -Scope Machine) -split ';' | Where-Object { $_ -ne '' })
    $filtered = @($entries | Where-Object {
            [System.IO.Path]::GetFullPath($_) -notin $removePaths
        })

    $ret = $filtered.Count -lt $entries.Count
    if ($ret) {
        Set-EnvironmentPath ($filtered -join ';') -Scope Machine
    }

    # The seam no-ops a variable that is not set, so only a real removal is written and announced.
    foreach ($variableName in $EnvironmentVariables) {
        Set-PermanentEnvironmentVariable $variableName $null -Scope Machine
    }

    return $ret
}
