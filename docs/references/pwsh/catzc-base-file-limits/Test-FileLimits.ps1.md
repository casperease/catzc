# pwsh/Catzc.Base.FileLimits/Test-FileLimits.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The quality gate for file limits: checks every tracked file in scope against its length and width limits.

### description

Generated targets, the vendor folder and the unordered track are out of scope. A length breach fails unless the file is in the exempt map
with its reason; a width breach is only reported while its class's width_mode is report. A file no language, extension or file name declares
fails as unclassified.

### parameter `Path`

The repository-relative paths to check; every tracked file by default.

### parameter `OutputFolder`

Where the report is written; the gate's own folder under out/ by default.

### parameter `PassThru`

Return the gate result as well as writing the report.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru.

### example 1

```powershell
Test-FileLimits
```
