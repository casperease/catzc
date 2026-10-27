# pwsh/Base.Flow/Get-PipelineType.ps1

The one reader of a pipeline's type from its file name: the prefix names the type, the rest the unit, for every engine's flow reader.

## help

### synopsis

Returns a pipeline's type and unit from its file name's prefix.

### description

A pipeline file's name starts with its type's prefix (ci-, cd-, cde-, deploy-, cron-, input-) and names its unit after it, so `cd-apex` is a
CD pipeline of the unit apex. The longest prefix is tried first, so `cde-` is never read as `cd-`. A name with no known prefix is of type
`unknown`, its whole name the unit. Every engine's flow reader asks this one command, so the prefixes are declared once.

### parameter `Name`

The pipeline's file name, without its folder or extension.

### outputs

`[pscustomobject]` `{ Type; Unit }`.

### example 1

```powershell
Get-PipelineType cd-apex
```
