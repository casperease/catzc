<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
    name: remove-system-installation
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
    docs: "[Remove-SystemInstallation.ps1.md](docs/references/pwsh/catzc-tooling-core/Remove-SystemInstallation.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SYSTEMTESTSATLTHREE
---
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
