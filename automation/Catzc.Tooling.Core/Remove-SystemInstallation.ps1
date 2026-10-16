<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#33
  config:
    synopsis: Removes an installation directory and cleans it from system PATH.
    description: |-
      Shared helper for Remove-NodeJs, Remove-Python, etc. Deletes the
      directory, removes matching entries from the system (Machine) PATH,
      and clears the specified Machine environment variables. Windows-only.

      Every persistent write goes through its seam — Set-EnvironmentPath for
      the PATH, Set-PermanentEnvironmentVariable for a variable — which
      announces the change; Windows broadcasts WM_SETTINGCHANGE on each
      persistent write, so running shells pick it up
      ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
    parameters:
      InstallDir: Resolved absolute path to the installation directory.
      ExtraPathDirs: |-
        Subdirectory names under InstallDir that are also on PATH
        (e.g. 'Scripts' for Python, 'wbin' for AzCli).
      EnvironmentVariables: System-level environment variable names to clear.
    outputs: '[bool] Whether the system PATH changed.'
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
