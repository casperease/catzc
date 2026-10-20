<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/ConvertTo-TestRunManifestEntry.ps1
    folder: private
    name: convert-to-test-run-manifest-entry
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/ConvertTo-TestRunManifestEntry.Tests.ps1
    docs: "[ConvertTo-TestRunManifestEntry.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/ConvertTo-TestRunManifestEntry.ps1.md)"
---
#>

function ConvertTo-TestRunManifestEntry {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [AllowNull()]
        [object] $WorkerRun
    )

    $entries = [ordered]@{
        shardExitCodes  = @{}
        durationSeconds = 0
    }
    if (-not $WorkerRun) {
        return $entries
    }

    if ($WorkerRun.PSObject.Properties['ShardExitCodes']) {
        $entries['shardExitCodes'] = $WorkerRun.ShardExitCodes
    }
    $entries['durationSeconds'] = [math]::Round($WorkerRun.DurationSeconds, 2)
    $location = (Get-TestRunLocationSummary -Location $WorkerRun.Location).Manifest
    foreach ($key in $location.Keys) {
        $entries[$key] = $location[$key]
    }
    $entries
}
