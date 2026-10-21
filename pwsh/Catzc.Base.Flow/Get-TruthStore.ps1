function Get-TruthStore {
    <#
    .SYNOPSIS
        Emits the truth stores of truth-stores.yml as data: each store's name, kind, URL and owning state machine.

    .DESCRIPTION
        The query a question about where truth lives is answered by (ADR-THES-ONETRUTH-TRUTHISQUERYABLE): every store catzc reads, writes
        or reports to is one entry of truth-stores.yml, classified by its kind (ADR-THES-STORES-THREEKINDS). With no filter it emits every
        store in declared order.

    .PARAMETER Name
        Only the stores with these names.

    .PARAMETER Kind
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
        [string[]] $Kind
    )

    foreach ($store in (Get-Config -Config truth-stores).stores) {
        if ((-not $Name -or $Name -ccontains $store.name) -and (-not $Kind -or $Kind -ccontains $store.kind)) {
            $store
        }
    }
}
