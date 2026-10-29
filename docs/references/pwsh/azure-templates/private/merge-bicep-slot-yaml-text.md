# pwsh/Azure.Templates/private/Merge-BicepSlotYamlText.ps1

The private function that writes parameter entries and the resource group into a slot config's text, keeping every other line.

## help

### synopsis

Replaces or appends parameter blocks under `ParametersFile.parameters` and sets the top-level `ResourceGroup` line of a slot config text.

### description

Each entry is rendered as yml, indented under `parameters:`, and replaces the block of the parameter with that key, or is appended after the
last parameter. The blank and comment lines that end a block stay with what follows it, so the comments and order of the file survive. The
`ResourceGroup: <name>` line replaces an existing one or goes right above `ParametersFile:`
([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)). A missing
`ParametersFile:` or `parameters:` line is added.

### parameter `Text`

The slot config's text.

### parameter `Parameters`

The parameter entries to write, keyed by parameter name.

### parameter `ResourceGroup`

The resource group name to declare. Omitted, the line is left as it is.
