# pwsh/Base.Asserts/Assert-True.ps1

The assertion that a value is exactly the boolean `$true`; any other value, including `$null`, throws.

## help

### synopsis

Asserts that a value is boolean $true.

### parameter `Value`

The value to test. Must be exactly `[bool]` $true.

### parameter `ErrorText`

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-True $result
```

### example 2

```powershell
Assert-True ($x -eq 1) -ErrorText 'x must equal 1'
```
