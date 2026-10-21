<#
---
catzc:
  immutable:
    with_body_sha: a8adf58add19
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Tests.ps1
    docs: "[Get-ContractCheckResults.ps1.md](docs/references/pwsh/catzc-base-contracts/Get-ContractCheckResults.ps1.md)"
    cites:
      - ADR-PWSH-VERBS-SEMANTICCONTRACT
      - ADR-PWSH-VERBS-PLURALCOLLECTIONNOUNS
      - ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE
      - ADR-REPO-CONTRACT-PROVENBYTESTS
      - ADR-REPO-CONTRACT-CONTRACTASSET
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
