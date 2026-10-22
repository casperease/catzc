# pwsh/Catzc.Base.QualityGates/private/Get-WrapFreeStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

A SHA-256 of a file's text with every run of whitespace collapsed to one space, so a change of wrapping alone leaves it unchanged.

### description

Format-Code stamps each file before its formatter engine runs and again after, and counts a changed file whose stamp held as changed only
in wrapping. The stamp is the uppercase hex of the hash of the trimmed, collapsed text, read as UTF-8. A missing file has no stamp: it
returns `$null`, so a change to it never reads as wrapping only.

### parameter `Path`

The file to stamp.

### outputs

`[string]` the stamp, or `$null` for a missing file.

### example 1

```powershell
Get-WrapFreeStamp -Path $file
```
