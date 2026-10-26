# pwsh/Base.QualityGates/private/Get-DrsCitationPath.ps1

A flat view of the citation map: it maps every ADR citation code to its ADR's repository-relative path. The Markdown heading normal form
uses it to write a moved citation as a link to its ADR.

## help

### synopsis

Maps every ADR citation code to its ADR's repository-relative path.

### description

A flat view of the citation map (Get-DrsCitationMap) for the Markdown heading normal form, which writes a moved citation as a link to its
ADR.

### parameter `RepositoryRoot`

The repository root whose ADR index is read.

### outputs

`[hashtable]` citation code -> repository-relative ADR path.
