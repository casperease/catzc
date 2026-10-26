# pwsh/Base.QualityGates/private/Get-WrapFreeStamp.ps1

A SHA-256 of a file's text with every run of whitespace collapsed to one space, so a change of wrapping alone leaves it unchanged. Format-Code
stamps a file before and after its formatter engine runs, and a held stamp marks a wrap-only change.

## help

### synopsis

A SHA-256 of a file's text with every run of whitespace collapsed to one space, so a change of wrapping alone leaves it unchanged.

### description

Format-Code stamps each file before its formatter engine runs and again after, and counts a changed file whose stamp held as changed only in
wrapping. The stamp is the uppercase hex of the hash of the trimmed, collapsed text, read as UTF-8. A missing file has no stamp: it returns
`$null`, so a change to it never reads as wrapping only.

### parameter `Path`

The file to stamp.

### outputs

`[string]` the stamp, or `$null` for a missing file.

### example 1

```powershell
Get-WrapFreeStamp -Path $file
```
