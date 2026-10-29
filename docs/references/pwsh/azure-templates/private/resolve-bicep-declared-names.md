# pwsh/Azure.Templates/private/Resolve-BicepDeclaredNames.ps1

The private function that renders every declared name in a slot value again under the configured naming order.

## help

### synopsis

Matches each string leaf of a value as a resource name and renders it again under the configured order.

### description

A map or a list is walked to its string leaves. Each leaf is matched by ConvertFrom-AzureResourceName under the `naming` variant first and
then under every other order of Get-AzureNameOrderSet, and its components are rendered by Get-AzureResourceName under the variant
([ADR-AZ-NAMING-ORDERISVARIANT](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-orderisvariant)). A leaf with no single
match is returned as written, with a warning that names its location.

### parameter `Value`

The slot value: a name, or a map or list holding names.

### parameter `CandidateSet`

The known value of each name part, from Get-BicepNameCandidateSet.

### parameter `Location`

The file and parameter path a warning names.
