# pwsh/Base.FileLimits/Measure-FileShape.ps1

The measurement of a file's shape: its line count and its widest line, in one streaming pass.

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
