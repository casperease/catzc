# pwsh/Base.Asserts/Assert-NotNull.ps1

The assertion that a value is not `$null`; it throws the caller's `-ErrorText` or a message with the file and line.

## help

### synopsis

Asserts that a value is not $null.

### parameter `Value`

The value to test. Must not be $null.

### parameter `ErrorText`

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-NotNull $result
```

### example 2

```powershell
Assert-NotNull $release -ErrorText 'GitHub API returned null'
```
