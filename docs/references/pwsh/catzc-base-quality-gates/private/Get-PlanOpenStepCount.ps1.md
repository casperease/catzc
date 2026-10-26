# pwsh/Base.QualityGates/private/Get-PlanOpenStepCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Counts the open steps of every plan in a plans folder: the one count Test-Plans checks and Format-Code writes.

### description

An open step is a `- [ ]` or `1. [ ]` list item, its continuation lines included, so a wrapped step counts once and a done step never. Only
`plan-*.md` files are counted; the master plan is left out.

### parameter `Folder`

The plans folder.

### parameter `Config`

The plans settings, which name the master file.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` plan file name to its open steps, in ordinal name order.
