# automation/Catzc.Base.Asserts/Assert-False.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a value is boolean $false.

### parameter Value

The value to test. Must be exactly `[bool]` $false.

### parameter ErrorText

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-False $result
```

### example 2

```powershell
Assert-False ($x -eq 1) -ErrorText 'x should not equal 1'
```
