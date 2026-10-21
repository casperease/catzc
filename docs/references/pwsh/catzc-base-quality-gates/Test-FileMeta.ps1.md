# pwsh/Catzc.Base.QualityGates/Test-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file meta quality gate: fails on any in-scope file whose meta block differs from what Format-FileMeta would write.

### description

A key no meta kind owns is reported too: the author decides whether it belongs in `config` or goes.

It rests on [ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate).

### parameter `Path`

Files or folders to check. Default: every in-scope file.

### parameter `RepositoryRoot`

The repository root paths are relative to. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-file-meta`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.

### outputs

Throws on any violation; with -PassThru, returns the result object.

### example 1

```powershell
Test-FileMeta
```

### example 2

```powershell
(Test-FileMeta -PassThru).Issues
```
