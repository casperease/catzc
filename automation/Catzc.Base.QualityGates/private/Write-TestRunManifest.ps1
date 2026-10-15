<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestRunManifest.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Writes a run directory's run.json — the atomic, self-describing record of a Test-Automation run's state.
.DESCRIPTION
    Completeness is read from this manifest, never inferred from which files exist, since streaming workers leave gaps.
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
