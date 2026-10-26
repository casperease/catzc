# pwsh/Base.QualityGates/private/Get-DrsUsageRow.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ADR citations and links one file makes, as rows of code and rule.

### description

The rows come from the file's text and its comment page through the processors the imprint uses (the `drs-codes` and `links` meta kinds),
never from its head ([ADR-REPO-FILEMETA-NOREADBACK](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)). The cited
codes give one row per citation: a rule code gives its ADR as Code and itself as Rule, and an ADR code is the whole ADR (Rule is null). A
Markdown file's links give a row for every link into a registered ADR, with the rule its anchor names (Rule is null for a link to the ADR
itself). A link to a document under docs/drs/ that no code owns, such as the index, gives no row.

### parameter `Text`

The whole file as text.

### parameter `Path`

The file's repository-relative path.

### parameter `Map`

The ADR citation map.

### parameter `Pages`

The comment-pages config, which finds a Markdown file's comment page so the links in it count as the file's own.

### parameter `Form`

The comment syntax of a code file (a Catzc.Base.CodeMeta.HeadForm), so a head it may carry is set apart from its text. Omitted for a
Markdown file.

### outputs

`[pscustomobject]` one @{ Path; Code; Rule; Source } per row, with Source `cites` or `link`.
