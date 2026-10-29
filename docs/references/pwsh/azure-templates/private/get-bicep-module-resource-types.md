# pwsh/Azure.Templates/private/Get-BicepModuleResourceTypes.ps1

A private helper of Resolve-BicepEnvironmentFacts. It lists the resource types the shared Bicep modules deploy, so a template can allow
exactly those types.

## help

### synopsis

Lists the resource types that the shared Bicep modules declare.

### description

Reads each `.bicep` file one level under the modules folder and collects the type of every `resource` declaration. An `existing` reference
is skipped, since the module does not deploy it. The result is sorted, case-insensitively unique, and read at build time, so a new module's
type needs no list edit.

Private helper of Resolve-BicepEnvironmentFacts; not exported.

### parameter `Path`

The folder holding the module files. Defaults to the modules place of the `vendor_azure.bicep` track.

### outputs

`[string[]]` The resource types, such as `Microsoft.Storage/storageAccounts`.

### example 1

```powershell
Get-BicepModuleResourceTypes
```
