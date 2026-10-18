<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Save-TestDurationHistory.ps1
    folder: private
    name: save-test-duration-history
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
    test: automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
---
#>

function Save-TestDurationHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $DurationMs,

        [ValidateRange(0, 0.999)]
        [double] $Decay
    )

    if (-not $PSBoundParameters.ContainsKey('Decay')) {
        $Decay = (Get-Config -Config test-policy).duration_decay
    }
    $history = Get-TestDurationHistory -Path $Path
    foreach ($key in $DurationMs.Keys) {
        $measured = [double] $DurationMs[$key]
        $kept = if ($history.Contains($key)) {
            $history[$key] * $Decay
        }
        else {
            0
        }
        $history[$key] = [Math]::Round([Math]::Max($measured, $kept))
    }
    $sorted = [ordered]@{}
    foreach ($key in @($history.Keys | Sort-Object)) {
        $sorted[$key] = $history[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
}
