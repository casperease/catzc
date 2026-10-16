<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/Test-Contracts.ps1
    name: test-contracts
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-CONTRACT#{2-6,10}
  config:
    synopsis: |-
      Quality gate: the repository honours every binding contract asset, every released version folder is unchanged,
      and contracts/ holds no dot-prefixed folder.
    description: |-
      Contracts are binding, proven by tests
      ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)). A quality gate
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) that checks three things.

      The binding assets. Each is checked by its kind with Get-ContractCheckResults
      ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
      - every asset, in both directions, of each unit's current version folder, -Version;
      - the provided assets of every other released version folder still in the tree. Released folders are the pin
        record: a version folder is kept while a consumer pins it, and retiring it means deleting the folder
        ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)). Their depended-on assets
        are not checked: a depended-on contract follows its outside platform, so only the current version's binds.
      Every finding is one issue naming the asset, its kind and direction, 'pinned' for an asset of an older release,
      and the finding.

      The freeze. Every version folder other than 0.0.0 is released, so immutable
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)): its files must match the
      .frozen record Publish-ContractRelease wrote when it froze the draft. A missing record, and each file changed,
      added or removed since, is one issue.

      The layout. contracts/ holds no dot-prefixed folder at any depth
      ([ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)): an asset whose target sits
      under a dot-prefixed root reaches it through its module's target root
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). Each outermost dot-prefixed
      folder is one issue (Get-ContractDotFolderFindings); a dot-prefixed file name, such as the .frozen record, is not.

      The current version folder is the draft, 0.0.0, on a devbox and in every build before a release. A release build
      freezes the draft with Publish-ContractRelease and then passes the resolved version with -Version; a named release
      that a unit holds no folder for is one issue, so the gate never passes over a release it did not check. A
      contracts/ tree that does not list (a malformed version folder, a file outside a module folder, a contract.yml
      entry naming no asset) is one issue. No assets at all is a clean pass. The gate reads files only: no git, no
      build.

      It ends through Write-QualityGateReport: the report goes to out/test-contracts/, every issue is printed, and the
      quality gate throws once listing them all; -PassThru returns the result instead.
    parameters:
      Version: 'The current version folder of every unit, <major>.<minor>.<patch>. Default: 0.0.0, each unit''s draft.'
      RepositoryRoot: 'The repository root that holds contracts/ and the files the assets constrain. Default: the loaded repository root.'
      OutputFolder: The report base folder. Defaults to out/test-contracts/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Version; Assets; PinnedAssets; FailedAssets;
        ReleasedFolders }) instead of throwing on issues. Assets counts every checked asset, PinnedAssets those of older
        releases among them.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-Contracts
      - Test-Contracts -Version 0.1.427
      - (Test-Contracts -PassThru).Issues
---
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
