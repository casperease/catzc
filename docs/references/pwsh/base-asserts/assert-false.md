# pwsh/Base.Asserts/Assert-False.ps1

The assertion that a value is exactly the boolean `$false`; any other value, including `$null`, throws.

## help

### synopsis

Asserts that a value is boolean $false.

### parameter `Value`

The value to test. Must be exactly `[bool]` $false.

### parameter `ErrorText`

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-False $result
```

### example 2

```powershell
Assert-False ($x -eq 1) -ErrorText 'x should not equal 1'
```
