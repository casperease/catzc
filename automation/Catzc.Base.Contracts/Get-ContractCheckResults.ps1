<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Get-ContractCheckResults.ps1
    kind: public-function
    module: Catzc.Base.Contracts
    visibility: public
    adrs:
      - ADR-PWSH-VERBS#2
      - ADR-PWSH-VERBS#6
      - ADR-REPO-CONTRACT#4
      - ADR-REPO-CONTRACT#6
---
#>

<#
.SYNOPSIS
    Checks contract assets against the real repository and returns one result per asset.
.DESCRIPTION
    A failed check is a result with Passed false, never an exception; only misuse throws.
.PARAMETER Asset
    The assets to check. Default: Get-Contract's assets, every unit's draft.
.PARAMETER RepositoryRoot
    The repository root that holds contracts/ and the target files. Default: the loaded repository root.
.OUTPUTS
    [Catzc.Base.Contracts.ContractCheckResult[]] in the order the assets arrive.
.EXAMPLE
    Get-ContractCheckResults
.EXAMPLE
    Get-Contract -Module Catzc.Tooling.Github | Get-ContractCheckResults | Where-Object { -not $_.Passed }
#>
function Get-ContractCheckResults {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractCheckResult[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [ValidateNotNull()]
        [Catzc.Base.Contracts.ContractAsset[]] $Asset,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    begin {
        if (-not [System.IO.Directory]::Exists($RepositoryRoot)) {
            throw [System.ArgumentException]::new("Get-ContractCheckResults: the repository root '$RepositoryRoot' does not exist.")
        }
    }

    process {
        foreach ($item in $Asset) {
            Get-ContractCheckResult -RepositoryRoot $RepositoryRoot -Asset $item
        }
    }

    end {
        if (-not $MyInvocation.ExpectingInput -and -not $PSBoundParameters.ContainsKey('Asset')) {
            foreach ($item in Get-Contract -RepositoryRoot $RepositoryRoot) {
                Get-ContractCheckResult -RepositoryRoot $RepositoryRoot -Asset $item
            }
        }
    }
}
