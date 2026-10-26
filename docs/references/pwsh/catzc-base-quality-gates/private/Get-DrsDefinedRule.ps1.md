# pwsh/Base.QualityGates/private/Get-DrsDefinedRule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The rules a Markdown text defines in its own rule headings, spelled as citations.

### description

A rule heading is `### Rule ADR-<CODE>:<n>`; the colon form is the rule's own heading and the result spells it `ADR-<CODE>#<n>`, in document
order.

It rests on [ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling).

### parameter `Text`

The Markdown body to read.

### outputs

`[string[]]` one `ADR-<CODE>#<n>` per defined rule, without duplicates.
