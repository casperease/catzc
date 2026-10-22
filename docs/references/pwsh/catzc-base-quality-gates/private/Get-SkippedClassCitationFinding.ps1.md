# pwsh/Catzc.Base.QualityGates/private/Get-SkippedClassCitationFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Finds comment pages that cite rules for a file whose class the drs-codes head fact skips, so the citations never reach its head.

### description

The drs-codes kind in file-meta.yml selects the file classes and languages whose head carries the rule codes their comment page cites. For
every tracked file with a comment page whose class and language that kind does not select, this reads the codes the page alone cites, with
the one parser of the codes (Get-DrsCodesFileMetaFact, given an empty body). A page that cites any yields one finding, anchored at the
page's first line: add the class to the select, or move the citations to a file the select covers. With no drs-codes kind in file-meta.yml
there is nothing to check and nothing is returned.

### parameter `RepositoryRoot`

The repository root the comment pages resolve against.

### parameter `Path`

Repository-relative files or folders to limit the check to. Default: every tracked file.

### outputs

`[string]` one finding line per file, `<page>:1 [SkippedClassCitation] …`.

### example 1

```powershell
Get-SkippedClassCitationFinding -RepositoryRoot (Get-RepositoryRoot) -Path pwsh/Catzc.Base.Widgets
```
