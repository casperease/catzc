<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-CommandContractMap.ps1.md"
  warning: "Generated Header"
---
#>

function Get-CommandContractMap {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $map = @{}
    foreach ($contract in @(Get-CommandContract -RepositoryRoot $RepositoryRoot)) {
        $map[$contract.Name] = $contract
    }
    $map
}
