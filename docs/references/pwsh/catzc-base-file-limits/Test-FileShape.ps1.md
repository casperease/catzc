# pwsh/Catzc.Base.FileLimits/Test-FileShape.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks files against their resolved limits and returns one finding per breach.

### description

Pure: it reads the files it is given and writes nothing. A length breach points at the last line and a width breach at the widest line,
each with its limit and where the limit came from. A file of the class none is not measured.

### parameter `Path`

The files to check.

### outputs

`[pscustomobject]` One finding per breach: Path, Line, Check, Value, Limit, Source and Message.

### example 1

```powershell
Test-FileShape -Path pwsh/Catzc.Base.Folders/Get-ChildPath.ps1
```
