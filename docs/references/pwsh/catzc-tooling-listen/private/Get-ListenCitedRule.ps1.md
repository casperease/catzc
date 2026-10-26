# pwsh/Tooling.Listen/private/Get-ListenCitedRule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the ADR codes a text cites, each once, in ordinal order.

### description

A code is any match of the drs config's cited code form. A domain's own prefix (ADR-AUTO) names no record, so a bare prefix is left out.

### parameter `Text`

The text to read, such as the added and removed lines of a diff; may be empty.

### outputs

`[string[]]` the cited codes, empty when the text cites none.
