<#
---
catzc:
  immutable:
    with_body_sha: "349c37f3c57a"
  edges:
    test: pwsh/Catzc.Base.Flow/tests/Get-TruthStore.Tests.ps1
    docs: "[Get-TruthStore.ps1.md](../../docs/references/pwsh/catzc-base-flow/Get-TruthStore.ps1.md)"
    cites:
      - TDR-ONETRUTH-TRUTHISQUERYABLE
      - TDR-STORES-THREEKINDS
---
#>

function Get-TruthStore {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Flow.TruthStore])]
    param(
        [ArgumentCompleter({ (Get-Config -Config truth-stores).stores.name })]
        [string[]] $Name,

        [ArgumentCompleter({ [Catzc.Base.Flow.TruthStoresConfig]::Kinds })]
        [string[]] $StoreKind
    )

    foreach ($store in (Get-Config -Config truth-stores).stores) {
        if ((-not $Name -or $Name -ccontains $store.name) -and (-not $StoreKind -or $StoreKind -ccontains $store.kind)) {
            $store
        }
    }
}
