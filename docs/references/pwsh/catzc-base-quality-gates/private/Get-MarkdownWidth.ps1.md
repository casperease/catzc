# pwsh/Base.QualityGates/private/Get-MarkdownWidth.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the width markdown prose wraps at, from its one declaration in file-limits.yml.

### description

The width Build-WidthConfigs renders into prettier's printWidth, read from its source rather than the rendered file, so a page the comment
engine writes is born in the formatter's shape and follows any later width change. Throws when file-limits.yml resolves no width for
markdown.

### outputs

`[int]` The markdown prose width.
