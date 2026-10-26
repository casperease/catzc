<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Test-Contracts.ps1.md"
  header: "generated"
---
#>

function Test-Contracts {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version = '0.1.0',

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
        $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
        foreach ($rootFolder in $layout.Folders($contractsRoot)) {
            $root = [System.IO.Path]::GetFileName($rootFolder)
            # Only the provided root releases; the layout check reports a release folder under a vendor root.
            if ($root -cne [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot) {
                continue
            }
            $versions = [string[]] @($layout.Folders($rootFolder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
            if ($Version -cne [Catzc.Base.Contracts.ContractLayout]::CurrentVersion -and
                $versions -cnotcontains $Version) {
                $issues.Add("contracts/$root/$Version/ does not exist, so release $Version of '$root' is not checked; a release freezes the current version with Publish-ContractRelease before it runs Test-Contracts -Version (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
            }
            foreach ($released in @($versions | Where-Object { $_ -match '^[0-9]+\.[0-9]+\.[0-9]+$' -and [int] $_.Split('.')[0] -ge 1 })) {
                $releasedFolders++
                foreach ($finding in @(Get-ContractFreezeFindings -Folder (Join-Path $rootFolder $released) -Name "contracts/$root/$released")) {
                    $issues.Add($finding)
                }
            }
        }
    }

    foreach ($finding in @(Get-ContractLayoutFindings -RepositoryRoot $RepositoryRoot)) {
        $issues.Add($finding)
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
