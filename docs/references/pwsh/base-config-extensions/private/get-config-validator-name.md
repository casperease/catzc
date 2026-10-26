# pwsh/Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1

The one place the config validator naming convention lives: it turns a config's kebab-case name into its `Assert-<Name>Config` function
name.

## help

### synopsis

Returns the conventional PowerShell validator name for a config: `Assert-<TitleCase(name)>Config`.

### description

The one place the validator naming convention lives: each kebab-case segment of the config name is title-cased (invariant culture) and
joined, so 'widget' becomes Assert-WidgetConfig and 'widget-parts' becomes Assert-WidgetPartsConfig.

### parameter `Name`

The config's kebab-case name, without the .yml extension.

### example 1

```powershell
Get-ConfigValidatorName -Name widget-parts
```
