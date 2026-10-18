# automation/Catzc.Base.QualityGates/private/Get-AdrUsageRow.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ADR citations one file's meta head holds, as rows of code and rule.

### description

Pure: it takes the text, the path and the citation map, and reads no file. The `cites` edge of the head gives one row per citation, a group
such as `ADR-X#{1,3}` expanded to its rules and a bare code kept as the whole ADR (Rule is null). The `links` edge gives a row for every
link into a registered ADR, with the rule its anchor names (Rule is null for a link to the ADR itself). A link to a document under docs/adr/
that no code owns, such as the index, gives no row.

### parameter Text

The whole file as text.

### parameter Path

The file's repository-relative path.

### parameter Map

The ADR citation map.

### parameter Form

The comment syntax of a code file's head (a Catzc.Base.CodeMeta.HeadForm). Omitted for a Markdown file, which carries its block in front
matter.

### outputs

`[pscustomobject]` one @{ Path; Code; Rule; Source } per row, with Source `head` or `link`.
