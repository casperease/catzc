# pwsh/Azure.Templates/private/Select-BicepOptionsYamlText.ps1

The private function that drops top-level keys from a template's `options.yml` text, keeping every other line.

## help

### synopsis

Returns the options text without the named top-level keys, their nested lines and the comment lines right above them.

### description

A top-level key in the exclude list is dropped with every indented or blank line under it, and with the comment lines that sit right above
it, since they describe it. Every other line stays in its order.

### parameter `Text`

The `options.yml` text.

### parameter `ExcludeKey`

The top-level keys to drop.
