# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterMemo.ps1

The private reader of the memo that holds the stamps each generated-file writer stored after its last run. It never throws on a bad memo; it
reads as empty.

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
