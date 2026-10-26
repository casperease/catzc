<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-flow/Get-TruthStore.ps1.md"
  header: "generated"
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
        if ((-not $Name -or $Name -ccontains $store.name) -and (-not $StoreKind -or
            $StoreKind -ccontains $store.kind)) {
            $store
        }
    }
}
