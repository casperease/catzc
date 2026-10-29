# pwsh/Azure.Templates/private/Resolve-BicepRuntimeSlotNames.ps1

The private function that derives the names of a runtime slot from the names its base slot declares.

## help

### synopsis

Matches each declared name of a base slot and renders the template's own names again with the runtime slot.

### description

A runtime slot has no file, so it is the one place where the names are still computed
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)). Each string leaf
under a parameter whose key ends in `Name` or `Names`, and the base slot's `ResourceGroup`, is matched by ConvertFrom-AzureResourceName
under the `naming` variant. A name whose short_name is the template's own is rendered again by Get-AzureResourceName with the runtime slot.
A name of another template, a parameter with a `naming_exception` and a value that is no name are returned as written. A name with no single
match throws, since a runtime slot never deploys into a guessed name. The result holds the `Parameters` map and the `ResourceGroup`.

### parameter `TemplateDescriptor`

The template whose own names take the runtime slot.

### parameter `Parameters`

The base slot's declared parameters, each a map with its `value`.

### parameter `ResourceGroup`

The base slot's declared resource group; empty for a Subscription target.

### parameter `RuntimeSlot`

The runtime slot's name, which every own name takes.

### parameter `CandidateSet`

The known value of each name part, from Get-BicepNameCandidateSet when not given.
