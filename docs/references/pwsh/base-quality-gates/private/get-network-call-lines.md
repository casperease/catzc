# pwsh/Base.QualityGates/private/Get-NetworkCallLines.ps1

The reader of Test-NetworkCalls: it gives the lines of one tracked file, or nothing when the file is gone or binary.

## help

### synopsis

Reads the lines of one repository file for the network-call search.

### description

Reads the file as UTF-8 and splits it into lines. A file that is missing on disk, or that holds a NUL byte in its first 8000 bytes, holds no
code to search, so the function returns nothing for it.

### parameter `Root`

The repository root the file is relative to.

### parameter `File`

The repository-relative path of the file.

### outputs

`[string[]]` The file's lines, or nothing.
