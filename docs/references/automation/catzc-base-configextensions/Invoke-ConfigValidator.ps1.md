# automation/Catzc.Base.ConfigExtensions/Invoke-ConfigValidator.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Validates a parsed config with a PowerShell validator, run in the owning module's scope.

### description

The PowerShell extension point for config validation. Core configs validate through a C# config type registered in configs.yml (Get-Config);
a config whose owner cannot ship a C# type validates here instead, with a PowerShell function that receives the parsed dictionary and throws
on a violation.

The validator is found by convention, `Assert-<TitleCase(name)>Config` (so 'widget-parts' is Assert-WidgetPartsConfig), or named with
-Validator. It is resolved and run inside the owning module (`& (Get-Module $Module) { … }`), so a private validator works and the result is
the same whichever module calls. With the conventional name and no such function, nothing runs and nothing is returned; a -Validator that
does not exist throws.

### parameter Config

The parsed config (e.g. ConvertFrom-Yaml -Ordered output).

### parameter Name

The config's kebab-case name, without the .yml extension.

### parameter Module

The module that owns the config and its validator.

### parameter Validator

A validator function name to use instead of the conventional one.

### outputs

`[string]` The name of the validator that ran; nothing when no conventional validator exists.

### example 1

```powershell
Invoke-ConfigValidator -Config $parsed -Name widget -Module TstWidget
```
