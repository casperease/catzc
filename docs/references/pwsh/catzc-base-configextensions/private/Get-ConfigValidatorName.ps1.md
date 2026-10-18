# automation/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
