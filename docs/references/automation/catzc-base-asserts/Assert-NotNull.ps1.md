# automation/Catzc.Base.Asserts/Assert-NotNull.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a value is not $null.

### parameter Value

The value to test. Must not be $null.

### parameter ErrorText

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-NotNull $result
```

### example 2

```powershell
Assert-NotNull $release -ErrorText 'GitHub API returned null'
```
