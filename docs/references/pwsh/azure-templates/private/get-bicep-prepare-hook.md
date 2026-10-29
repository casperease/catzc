# pwsh/Azure.Templates/private/Get-BicepPrepareHook.ps1

A private helper of the Bicep build. It finds the per-template hook that may adjust a slot's configuration before the parameters file is
written.

## help

### synopsis

Returns a template's `Invoke-BicepPrepareParameterSet` hook, when it has one.

### description

A template may carry its own PrePost module. When it does, the module is imported locally, set to strict mode like every catzc module, and
the exported `Invoke-BicepPrepareParameterSet` command is returned. A template with no PrePost module, or one that does not export the hook,
yields nothing, and the slot's configuration is used unchanged.

Private helper of the Bicep build; not exported.

### parameter `TemplateDescriptor`

The template, as Get-BicepTemplate returns it.

### outputs

`[System.Management.Automation.CommandInfo]` The hook command, or nothing.

### example 1

```powershell
Get-BicepPrepareHook -TemplateDescriptor $template
```
