# pwsh/Tooling.Listen/private/Get-ListenCitedRule.ps1

A private helper of the listen module that extracts the ADR codes a piece of text cites, which is how a change record names the rules its diff
touches.

## help

### synopsis

Lists the ADR codes a text cites, each once, in ordinal order.

### description

A code is any match of the drs config's cited code form. A domain's own prefix (ADR-AUTO) names no record, so a bare prefix is left out.

### parameter `Text`

The text to read, such as the added and removed lines of a diff; may be empty.

### outputs

`[string[]]` the cited codes, empty when the text cites none.
