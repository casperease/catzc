# pwsh/Base.Languages/private/Get-GeneratedWriterRow.ps1

A private helper of Format-GeneratedFileHead. It reads the one writer-registry row a generated head is stamped from.

## help

### synopsis

Returns the one row of the writer registry that declares the named writer.

### description

Every module's `generated` config is read, through Get-Config with its owners listed, and the rows whose `name` is the given one, compared
case-sensitively, are gathered. Exactly one row must match; none or several throw, since a stamp needs exactly one row.

Private helper of Format-GeneratedFileHead; not exported.

### parameter `Name`

The writer's name, as its registry row declares it.

### outputs

`[Catzc.Base.Variants.GeneratedWriterRow]` The writer's row.

### example 1

```powershell
Get-GeneratedWriterRow -Name Build-WidgetPage
```
