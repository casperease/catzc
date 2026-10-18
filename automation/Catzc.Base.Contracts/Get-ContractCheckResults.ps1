<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/Get-ContractCheckResults.ps1
    name: get-contract-check-results
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Tests.ps1
    cites:
      - ADR-PWSH-VERBS#{2,6}
      - ADR-REPO-CMDCONTRACT#4
      - ADR-REPO-CONTRACT#{4,6}
---
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
