<#
---
catzc:
  immutable:
    with_body_sha: "9cef903a3bd4"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
    docs: "[Test-Contracts.ps1.md](../../docs/references/pwsh/catzc-base-contracts/Test-Contracts.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-KEPTWHILEPINNED
      - ADR-REPO-CONTRACT-PROVENBYTESTS
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-CONTRACT-NODOTFOLDERS
---
#>

function Test-Contracts {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version = '0.0.0',

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $assets = @()
    try {
        $assets = @(Get-ContractBindingAssets -Version $Version -RepositoryRoot $RepositoryRoot)
    }
    catch {
        $issues.Add("contracts/ does not list — $($_.Exception.Message)")
    }

    $failedAssets = 0
    if ($assets.Count -gt 0) {
        foreach ($result in @(Get-ContractCheckResults -Asset $assets -RepositoryRoot $RepositoryRoot)) {
            if ($result.Passed) {
                continue
            }
            $failedAssets++
            $pinned = ''
            if ($result.Asset.Version -cne $Version) {
                $pinned = ', pinned'
            }
            foreach ($finding in $result.Findings) {
                $issues.Add("$($result.Asset.AssetPath) ($($result.Asset.Kind), $($result.Asset.Direction)$pinned): $finding")
            }
        }
    }

    $releasedFolders = 0
    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if ([System.IO.Directory]::Exists($contractsRoot)) {
        $unitFolders = [string[]] [System.IO.Directory]::GetDirectories($contractsRoot)
        [System.Array]::Sort($unitFolders, [System.StringComparer]::Ordinal)
        foreach ($unitFolder in $unitFolders) {
            $unit = [System.IO.Path]::GetFileName($unitFolder)
            $versions = [string[]] @([System.IO.Directory]::GetDirectories($unitFolder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
            [System.Array]::Sort($versions, [System.StringComparer]::Ordinal)
            if ($Version -cne '0.0.0' -and $versions -cnotcontains $Version) {
                $issues.Add("contracts/$unit/$Version/ does not exist, so release $Version of '$unit' is not checked; a release freezes the draft with Publish-ContractRelease before it runs Test-Contracts -Version (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
            }
            foreach ($released in @($versions | Where-Object { $_ -match '^[0-9]+\.[0-9]+\.[0-9]+$' -and $_ -cne '0.0.0' })) {
                $releasedFolders++
                foreach ($finding in @(Get-ContractFreezeFindings -Folder (Join-Path $unitFolder $released) -Name "contracts/$unit/$released")) {
                    $issues.Add($finding)
                }
            }
        }
    }

    foreach ($finding in @(Get-ContractDotFolderFindings -RepositoryRoot $RepositoryRoot)) {
        $issues.Add($finding)
    }

    $facts = [ordered]@{
        Version         = $Version
        Assets          = $assets.Count
        PinnedAssets    = @($assets | Where-Object { $_.Version -cne $Version }).Count
        FailedAssets    = $failedAssets
        ReleasedFolders = $releasedFolders
    }
    Write-QualityGateReport -Subject contracts -Title Test-Contracts -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
