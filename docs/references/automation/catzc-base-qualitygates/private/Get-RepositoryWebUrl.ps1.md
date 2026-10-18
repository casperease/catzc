# automation/Catzc.Base.QualityGates/private/Get-RepositoryWebUrl.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns this repository's GitHub web URL (`https://github.com/<owner>/<repo>`), or $null when it has none.

### description

Reads the origin remote from `<root>/.git/config` — no git process — and normalizes an https or ssh GitHub remote to its web URL. Test-Links
uses it to recognise an absolute URL into this repository, which belongs only under .github/
([ADR-REPO-LINK#7](../../../../adr/repository/markdown-links.md#rule-adr-repo-link7)). A root with no .git/config (a test fixture, an
exported build) or a non-GitHub remote yields $null, and that check is skipped.

### parameter RepositoryRoot

The repository root.

### outputs

`[string]` or $null.
