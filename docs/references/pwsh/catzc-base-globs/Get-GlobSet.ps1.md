# automation/Catzc.Base.Globs/Get-GlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns globsets from the globs.yml registry — all of them, or the named ones.

### description

The typed read of the single source of truth ([ADR-FLOW-CD-GLOBS#1](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)):
configs/globs.yml, loaded and validated through Get-Config as a `[Catzc.Base.Globs.GlobsConfig]`. Each result is a
`[Catzc.Base.Globs.GlobSet]` carrying the compiled include/exclude patterns and Matches(). An unknown name throws, naming the config file.

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
