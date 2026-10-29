# pwsh/Azure.Templates/private/Resolve-BicepEnvironmentFacts.ps1

A private helper of Get-BicepPreparedConfiguration. It resolves the facts a template's options.yml declares from the slot's azure.yml
environment, so a slot never writes them.

## help

### synopsis

Resolves the environment facts a template declares for a slot.

### description

For each parameter in the template's `facts`, reads the named field from azure.yml. `module_resource_types` is the types the shared modules
declare (Get-BicepModuleResourceTypes). `subscription_production`, `policy_enforcement` and `groups` follow the class of the slot's
subscription: a subscription that holds a production environment is production. `groups` is the group of each role of the slot's owner in
that class, empty when none. Any other field is read from the slot's environment. A template with no facts answers an empty set. A slot
whose environment or subscription azure.yml does not declare throws.

Private helper of Get-BicepPreparedConfiguration; not exported.

### parameter `TemplateDescriptor`

The template, as Get-BicepTemplate returns it.

### parameter `Slot`

The slot the facts are resolved for.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` Parameter name to resolved fact.

### example 1

```powershell
Resolve-BicepEnvironmentFacts -TemplateDescriptor $template -Slot $slot
```
