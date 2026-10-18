# pwsh/Catzc.Base.QualityGates/private/Get-HelpPageFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists what is wrong with the help a PowerShell file keeps in the `## help` section of its comment page.

### description

The faults ADR-REPO-HELP-FIVEFAULTSREPORTED names, each a sentence an author acts on and never rewritten: a file with no page or a page with
no synopsis, a subsection the shape does not name or one out of order, a parameter with no subsection, a subsection for a name the function
does not declare, the parameter subsections out of the `param` order, and an `outputs` text whose first type differs from `[OutputType]`. A
comment-based help block in the file and a help line made of nothing but a citation are reported too. The file is read with the PowerShell
parser, so a comment inside a string is never mistaken for help; a file that does not parse is no help fault and yields nothing.

### parameter `Text`

The text of one PowerShell function file or script.

### parameter `PageText`

The text of the file's comment page, or nothing when the file has none.

### outputs

`[string[]]` the findings, empty when the help is in shape.
