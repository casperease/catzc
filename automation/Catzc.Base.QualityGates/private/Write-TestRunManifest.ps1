<#
.SYNOPSIS
    Writes a run directory's run.json — the atomic, self-describing record of a Test-Automation run's state.
.DESCRIPTION
    A run directory's artifact files alone cannot tell a finished run from one still executing (or one that crashed...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestRunManifest.ps1.md#comment1)
.PARAMETER RunDirectory
    The run directory the manifest belongs to.
.PARAMETER Manifest
    The manifest content ([ordered] hashtable — serialized as-is; the caller owns the shape).
.OUTPUTS
    [string] The path to the written run.json.
#>
function Write-TestRunManifest {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Manifest
    )

    Assert-PathExist $RunDirectory -PathType Container

    $path = Join-Path $RunDirectory 'run.json'
    $temp = "$path.$PID.tmp"

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($temp, (ConvertTo-Json -InputObject $Manifest -Depth 4), $utf8NoBom)
    [System.IO.File]::Move($temp, $path, $true)

    $path
}
