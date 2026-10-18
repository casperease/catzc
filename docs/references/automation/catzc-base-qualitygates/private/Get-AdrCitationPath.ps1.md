# automation/Catzc.Base.QualityGates/private/Get-AdrCitationPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps every ADR citation code to its ADR's repository-relative path.

### description

A flat view of the citation map (Get-AdrCitationMap) for the Markdown heading normal form, which writes a moved
citation as a link to its ADR.

### parameter RepositoryRoot

The repository root whose ADR index is read.

### outputs

`[hashtable]` citation code -> repository-relative ADR path.
