# pwsh/Base.Asserts/Assert-NotNullOrWhitespace.ps1

The throwing form of `Test-NotNullOrWhitespace`: it throws when a value is null, empty or only whitespace.

## help

### synopsis

Asserts that a value is not null, empty, or whitespace.

### parameter `Value`

The value to test. Evaluated via `[string]::IsNullOrWhiteSpace(`).

### parameter `ErrorText`

Custom error message. Defaults to file and line info.

### example 1

```powershell
Assert-NotNullOrWhitespace $name
```
