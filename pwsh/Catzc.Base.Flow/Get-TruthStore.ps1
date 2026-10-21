<#
---
catzc:
  immutable:
    with_body_sha: ddba8f7b0af6
  edges:
    test: pwsh/Catzc.Base.Flow/tests/Get-TruthStore.Tests.ps1
    cites:
      - ADR-THES-ONETRUTH-TRUTHISQUERYABLE
      - ADR-THES-STORES-THREEKINDS
---
#>

function Get-TruthStore {
    <#
    .SYNOPSIS
        Emits the truth stores of truth-stores.yml as data: each store's name, kind, URL and owning state machine.

    .DESCRIPTION
        The query a question about where truth lives is answered by
        ([ADR-THES-ONETRUTH-TRUTHISQUERYABLE](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth-truthisqueryable)): every store catzc reads, writes
        or reports to is one entry of truth-stores.yml, classified by its kind
        ([ADR-THES-STORES-THREEKINDS](/docs/adr/thesis/truth-stores.md#rule-adr-thes-stores-threekinds)). With no filter
        it emits every
        store in declared order.

    .PARAMETER Name
        Only the stores with these names.

    .PARAMETER StoreKind
        Only the stores of these kinds.

    .OUTPUTS
        [Catzc.Base.Flow.TruthStore] per store.
    #>
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
