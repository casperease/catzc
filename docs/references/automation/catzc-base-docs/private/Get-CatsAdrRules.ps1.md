# automation/Catzc.Base.Docs/private/Get-CatsAdrRules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Extracts the id, one-line summary, and normative statement of each rule in a single ADR file.

### description

Reads an ADR markdown file and returns one entry per `### Rule <CODE>:<n>` heading: the rule id, the first non-empty line of its body
(Summary, the one-liner Show-Cats lists), and the whole first paragraph of its body joined into one line (Statement). The blank-line-padding
authoring convention ([index](../../../../adr/index.md)) makes that paragraph the rule's normative summary, ending at the blank line before
its linked bullets, so Statement never includes them. The glossary checks read Statement: a term bolded on a wrapped line still belongs to
the rule ([ADR-REPO-VOCAB#1](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).

Private helper for Show-Cats and the glossary checks; not exported.

### parameter `AdrPath`

Absolute path to the ADR markdown file.

### outputs

`[object[]]` One { Id; Summary; Statement } per rule heading, in document order.
