# automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds a config / resource-group identity name from an (environment, slot) pair.

### description

The config-name is `<environment>` for the base / index-0 slot, or `<environment>-<slot>` for a special slot. It names the config file
(`<config>.yml`), the build artifact (`parameters.<config>.json`), and is 1:1 with the resource group. The inverse (parse) is
Resolve-BicepConfigName. See [ADR-AZ-DATAMOD#2](../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2).

### parameter Environment

Environment name (a key in azure.yml's environments map).

### parameter Slot

Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base slot.

### example 1

```powershell
Get-BicepConfigName dev          # -> 'dev'
```

### example 2

```powershell
Get-BicepConfigName dev -Slot 001   # -> 'dev-001'
```
