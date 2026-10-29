# pwsh/Base.FileLimits/Test-FileShape.ps1

The pure check of files against their resolved limits, returning one finding per breach.

## help

### synopsis

Checks files against their resolved limits and returns one finding per breach.

### description

Pure: it reads the files it is given and writes nothing. A length breach points at the last line and a width breach at the widest line, each
with its limit and where the limit came from. A file of the class none is not measured.

### parameter `Path`

The files to check.

### outputs

`[pscustomobject]` One finding per breach: Path, Line, Check, Value, Limit, Source and Message.

### example 1

```powershell
Test-FileShape -Path pwsh/Base.Folders/Get-ChildPath.ps1
```

## String overflow

A line whose overflow lies wholly inside one string literal passes, so the width is the widest line that is not one.

## comment:1

Above `$text = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath...`, written with `#`.

```text
A line whose overflow lies wholly inside one string literal passes, so the width is the widest line that is not one.
Through the provider, as Measure-FileShape reads it: .NET resolves a relative path against the process directory, not the location.
```
