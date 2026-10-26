# pwsh/Base.Flow/Get-Rung.ps1

The reader of the rungs registry: it returns the rungs of the promotion ladder, in climbing order, as typed records.

## help

### synopsis

Returns the rungs of the promotion ladder, in climbing order.

### description

Reads the rungs registry ([FDR-CD-RUNGSREGISTRY](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)): each
rung with the gate a commit clears to enter it and the configuration environment it deploys. A unit's ADO environment for a rung is
`<unit>-<rung>`.

### parameter `Name`

The rungs to return. Default: every rung.

### outputs

`[Catzc.Base.Flow.Rung]` One record per rung.

### example 1

```powershell
Get-Rung -Name release-uat
```
