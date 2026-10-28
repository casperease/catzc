# pwsh/Base.QualityGates/private/Get-DrsCitationPath.ps1

A flat view of the citation map: it maps every citation code to its record's repository-relative path. The Markdown heading normal form uses
it to write a moved citation as a link to its record.

## help

### synopsis

Maps every citation code to its record's repository-relative path.

### description

A flat view of the citation map (Get-DrsCitationMap) for the Markdown heading normal form, which writes a moved citation as a link to its
record.

### parameter `RepositoryRoot`

The repository root whose DRS index is read.

### outputs

`[hashtable]` citation code -> repository-relative record path.
