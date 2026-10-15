<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Test-Contracts.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-CONTRACT#10
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#3
      - ADR-REPO-CONTRACT#4
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
---
#>

<#
.SYNOPSIS
    Quality gate: the repository honours every binding contract asset, every released version folder is unchanged,
    and contracts/ holds no dot-prefixed folder.
.DESCRIPTION
    Depended-on assets of older releases are not checked: they follow their outside platform, so only the current binds.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2),
    [ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3),
    [ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4),
    [ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5),
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
    [ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)
    [comment:1](/docs/references/automation/catzc-base-contracts/Test-Contracts.ps1.md#comment1)
.PARAMETER Version
    The current version folder of every unit, <major>.<minor>.<patch>. Default: 0.0.0, each unit's draft.
.PARAMETER RepositoryRoot
    The repository root that holds contracts/ and the files the assets constrain. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-contracts/ (Write-QualityGateReport).
.PARAMETER PassThru
    Without it the gate throws on issues; Assets counts every checked asset, PinnedAssets those of older releases.
    [comment:2](/docs/references/automation/catzc-base-contracts/Test-Contracts.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Contracts
.EXAMPLE
    Test-Contracts -Version 0.1.427
.EXAMPLE
    (Test-Contracts -PassThru).Issues
#>
function Test-Contracts {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
                $issues.Add("contracts/$unit/$Version/ does not exist, so release $Version of '$unit' is not checked; a release freezes the draft with Publish-ContractRelease before it runs Test-Contracts -Version (ADR-REPO-CONTRACT#5).")
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
