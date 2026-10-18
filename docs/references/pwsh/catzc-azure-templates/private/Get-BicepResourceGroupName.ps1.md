# pwsh/Catzc.Azure.Templates/private/Get-BicepResourceGroupName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives a template slot's resource-group name from the Azure naming standard.

### description

Convenience over Get-BicepResourceName for the resource-group type — the single source of the RG name for both Get-BicepDeploymentContext
(the deploy target) and Set-BicepTrackingTagSet (the tag scope), so the two never drift. The resource-group name is derived from the naming
standard, never hand-typed in config (one config file ⟷ one resource group).

### parameter `Template`

Template name.

### parameter `Environment`

Environment shortname.

### parameter `Slot`

Optional special-slot discriminator; omitted selects the env's base / index-0 slot.

### parameter `Customer`

Optional customer; renders into the RG name and is required to disambiguate a per-customer RG.

### example 1

```powershell
Get-BicepResourceGroupName -Template sample -Environment dev          # -> dev-weu-zct-smpl-rg
```

### example 2

```powershell
Get-BicepResourceGroupName -Template sample -Environment dev -Customer apex   # -> dev-weu-zct-smpl-apex-rg
```

### example 3

```powershell
Get-BicepResourceGroupName -Template sample-indexed -Environment dev -Slot 001
# -> dev-001-weu-zct-sidx-rg
```
