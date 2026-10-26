# pwsh/Base.QualityGates/private/Get-MarkdownWidth.ps1

The width markdown prose wraps at, read from its one declaration in file-limits.yml. It reads the source rather than the rendered prettier
config, so a page the comment engine writes is born in the formatter's shape.

## help

### synopsis

Returns the width markdown prose wraps at, from its one declaration in file-limits.yml.

### description

The width Build-WidthConfigs renders into prettier's printWidth, read from its source rather than the rendered file, so a page the comment
engine writes is born in the formatter's shape and follows any later width change. Throws when file-limits.yml resolves no width for
markdown.

### outputs

`[int]` The markdown prose width.
