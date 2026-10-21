# pwsh/Catzc.Base.Flow/Get-Rung.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the rungs of the promotion ladder, in climbing order.

### description

Reads the rungs registry
([FDR-CD-RUNGSREGISTRY](../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)): each rung with the gate
a commit clears to enter it and the configuration environment it deploys. A unit's ADO environment for a rung is `<unit>-<rung>`.

### parameter `Name`

The rungs to return. Default: every rung.

### outputs

`[Catzc.Base.Flow.Rung]` One record per rung.

### example 1

```powershell
Get-Rung -Name release-uat
```
