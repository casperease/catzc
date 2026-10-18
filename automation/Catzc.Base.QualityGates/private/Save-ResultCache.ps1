<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Save-ResultCache.ps1
    folder: private
    name: save-result-cache
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
    test: automation/Catzc.Base.QualityGates/tests/Save-ResultCache.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#10
---
#>

function Save-ResultCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Cache
    )

    $merged = Get-ResultCache -Path $Path
    foreach ($key in @($Cache.Keys)) {
        $merged[$key] = $Cache[$key]
    }
    $sorted = [ordered]@{}
    foreach ($key in @($merged.Keys | Sort-Object)) {
        $sorted[$key] = $merged[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    $staging = "$Path.$PID.tmp"
    try {
        [System.IO.File]::WriteAllText($staging, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($staging, $Path, $true)
    }
    catch [System.IO.IOException], [System.UnauthorizedAccessException] {
        Write-Message "Skipped saving the result cache at '$Path': $($_.Exception.Message)"
    }
    finally {
        if ([System.IO.File]::Exists($staging)) {
            [System.IO.File]::Delete($staging)
        }
    }
}
