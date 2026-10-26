# pwsh/Base.Flow/Get-TruthStore.ps1

The query behind every question about where truth lives: it emits the truth stores of `truth-stores.yml` as data.

## help

### synopsis

Emits the truth stores of truth-stores.yml as data: each store's name, kind, URL and owning state machine.

### description

The query a question about where truth lives is answered by
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)): every store catzc reads,
writes or reports to is one entry of truth-stores.yml, classified by its kind ([TDR-STORES-THREESTOREKINDS][r1]). With no filter it emits
every store in declared order.

### parameter `Name`

Only the stores with these names.

### parameter `StoreKind`

Only the stores of these kinds.

### outputs

`[Catzc.Base.Flow.TruthStore]` per store.

### example 1

```powershell
Get-TruthStore -StoreKind fact-source | Select-Object -ExpandProperty name
```

[r1]: ../../../drs/thesis/truth-stores.md#rule-tdr-stores-threestorekinds
