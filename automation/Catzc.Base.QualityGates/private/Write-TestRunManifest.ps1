<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Write-TestRunManifest.ps1
    folder: private
    name: write-test-run-manifest
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Write-TestRunManifest.Tests.ps1
  config:
    synopsis: Writes a run directory's run.json — the atomic, self-describing record of a Test-Automation run's state.
    description: |-
      A run directory's artifact files alone cannot tell a finished run from one still executing (or one that
      crashed mid-flight): a reader listing the folder while workers stream would see "missing" shard files
      and misread a partial run as the whole truth. run.json closes that gap — Test-Automation writes it once
      at run start ({ status: 'running', … }) and once more, terminally, in a finally ({ status:
      'passed'|'failed'|'crashed', … }), so completeness is read from the manifest, never inferred from which
      files happen to exist yet. A run whose owning process died never reaches that finally; the next run in the
      same report folder rewrites it as 'abandoned' (Set-AbandonedTestRun, from the ownerPid/ownerStart the
      'running' record carries).

      The write is atomic: the JSON lands in a temp file first and is moved over run.json in one filesystem
      operation (the compiled-DLL pattern), so a concurrent reader never sees a half-written manifest.
    parameters:
      RunDirectory: The run directory the manifest belongs to.
      Manifest: The manifest content ([ordered] hashtable — serialized as-is; the caller owns the shape).
    outputs: '[string] The path to the written run.json.'
---
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
