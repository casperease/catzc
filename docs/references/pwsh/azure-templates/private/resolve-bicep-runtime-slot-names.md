# pwsh/Azure.Templates/private/Resolve-BicepRuntimeSlotNames.ps1

The private function that derives the names of a runtime slot from the names its base slot declares.

## help

### synopsis

Matches each declared name of a base slot and renders the template's own names again with the runtime slot.

### description

A runtime slot has no file, so it is the one place where the names are still computed
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)). Each string leaf
the naming quality gate reads as a name (Get-BicepSlotNameLeaf: a key on its path ends in `Name` or `Names`, and none in a `not_names`
suffix of `resource-types.yml`), and the base slot's `ResourceGroup`, is matched by ConvertFrom-AzureResourceName under the `naming`
variant. A name on the base slot's own coordinates, its short_name the template's own, its env and customer the base slot's and no slot of
its own, is rendered again by Get-AzureResourceName with the runtime slot. A name of another template, a name of another slot of the same
template (a hub in another environment, or a special slot such as `001`), a parameter with a `naming_exception` and a value that is no name
are returned as written. A name with no single match throws, since a runtime slot never deploys into a guessed name. The result holds the
`Parameters` map and the `ResourceGroup`.

### parameter `TemplateDescriptor`

The template whose own names take the runtime slot.

### parameter `Parameters`

The base slot's declared parameters, each a map with its `value`.

### parameter `ResourceGroup`

The base slot's declared resource group; empty for a Subscription target.

### parameter `Environment`

The base slot's environment, which an own name carries.

### parameter `Customer`

The base slot's customer, which an own name carries; empty for the shared platform.

### parameter `RuntimeSlot`

The runtime slot's name, which every own name takes.

### parameter `CandidateSet`

The known value of each name part, from Get-BicepNameCandidateSet when not given.
