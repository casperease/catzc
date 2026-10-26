# pwsh/Base.FileLimits/Measure-FileShape.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Measures a file's line count and its widest line in one streaming pass.

### description

The file is read line by line and never held in memory, so a large tree measures fast. Width counts the characters of a line without its
line ending.

### parameter `Path`

The files to measure. Each must exist.

### outputs

`[Catzc.Base.FileLimits.FileShape]` The path, the line count, the widest width and that line's number.

### example 1

```powershell
Measure-FileShape -Path README.md
```
