# pwsh/Catzc.Base.QualityGates/private/Get-GeneratedWriterMemo.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the stamps generated-file writers stored after their last run.

### description

A missing, unreadable or non-mapping memo reads as empty, so every writer is due rather than any being skipped on a memo nobody can trust.

### parameter `MemoPath`

The memo file, out/cache/generated-writers.json in a normal run.

### outputs

`[hashtable]` Writer name to stamp.

### example 1

```powershell
Get-GeneratedWriterMemo -MemoPath (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
```
