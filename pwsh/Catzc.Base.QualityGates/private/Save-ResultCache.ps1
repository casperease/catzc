<#
---
catzc:
  immutable:
    with_body_sha: "87f5f4c70e2f"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Save-ResultCache.Tests.ps1
    docs: "[Save-ResultCache.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Save-ResultCache.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
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
