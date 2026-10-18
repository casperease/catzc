# pwsh/Catzc.Base.Slides/private/Get-AdrRuleText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the registry text of one ADR rule, by its citation code.

### description

Resolves the code through the ADR citation map, opens the ADR, and returns the paragraph under the rule's heading as plain text, links
reduced to their text and whitespace collapsed, so a slide that quotes the rule can be compared to it (ADR-REPO-SLIDES-CHECKABLECLAIMS). Null when the
code is not of the form ADR-NAME#n or the index knows no such rule.

### parameter `Code`

One rule citation, such as ADR-PRIN-EAC-DIFFABLEBELONGSINVERSIONCONTROL.

### parameter `RepositoryRoot`

The repository root whose ADR index is read.

### outputs

`[string]` The rule's text, or null.
