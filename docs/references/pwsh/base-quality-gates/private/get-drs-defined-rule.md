# pwsh/Base.QualityGates/private/Get-DrsDefinedRule.ps1

Returns the rules a Markdown text defines in its own rule headings, spelled as citations and in document order. A heading
`### Rule ADR-<CODE>:<n>` gives the citation `ADR-<CODE>#<n>`.

## help

### synopsis

The rules a Markdown text defines in its own rule headings, spelled as citations.

### description

A rule heading is `### Rule ADR-<CODE>:<n>`; the colon form is the rule's own heading and the result spells it `ADR-<CODE>#<n>`, in document
order.

It rests on [ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling).

### parameter `Text`

The Markdown body to read.

### parameter `Form`

The drs code form, which a caller over many texts resolves once and passes in. Default: the `CodeForm` of the `drs` config.

### outputs

`[string[]]` one `ADR-<CODE>#<n>` per defined rule, without duplicates.
