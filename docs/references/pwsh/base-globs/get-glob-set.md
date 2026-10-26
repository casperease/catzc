# pwsh/Base.Globs/Get-GlobSet.ps1

The reader of the globset registry: it returns the declared globsets, all of them or the named ones, as typed `GlobSet` records loaded and
validated through `Get-Config` (`GlobsConfig.cs`).

## help

### synopsis

Returns globsets from the globs.yml registry — all of them, or the named ones.

### description

The typed read of the single source of truth
([FDR-CD-GLOBS-NAMEDGLOBSETS](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets)): configs/globs/, loaded and validated
through Get-Config as a `[Catzc.Base.Globs.GlobsConfig]`. Each result is a `[Catzc.Base.Globs.GlobSet]` carrying the compiled
include/exclude patterns and Matches(). An unknown name throws, naming the config file.

### parameter `Name`

The globset name(s) to return. Omit for every globset, in registry order.

### example 1

```powershell
Get-GlobSet
```

### example 2

```powershell
(Get-GlobSet -Name automation).Matches('automation/importer.ps1')
```
