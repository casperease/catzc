# pwsh/Base.FileLimits/Test-FileLimits.ps1

The quality gate that checks every tracked file in scope against the length and width limits of the file-limits config.

## help

### synopsis

The quality gate for file limits: checks every tracked file in scope against its length and width limits.

### description

Generated targets, the vendor folder and the unordered track are out of scope. A length breach fails unless the file is in the exempt map
with its reason; a width breach is only reported while its class's width_mode is report. A file no language, extension or file name declares
fails as unclassified. While `string_overflow` is `exempt`, its default, a line whose part past the width lies wholly inside one string
literal does not breach: the width is the widest line that is not one. Each language's own tokenizer judges the string (a PowerShell string,
a YAML scalar, an XML attribute value), so the overflow must end with the string; a language with no tokenizer exempts nothing.

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

## Scope

Generated, vendor and unordered files are out by their track: the generated targets as declared, the vendor folder and the unordered track.
A comment page is authored prose (ADR-REPO-COMMENTS-PAGEISAUTHORED) though its root is a generated target, so it stays in scope.
