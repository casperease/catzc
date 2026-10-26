# pwsh/Base.Asserts/Test-NotNullOrWhitespace.ps1

The query form that answers whether a value is neither null, empty nor whitespace; `Assert-NotNullOrWhitespace` is its throwing form.

## help

### synopsis

Tests whether a value is not null, empty, or whitespace.

### parameter `Value`

The value to test.

### example 1

```powershell
Test-NotNullOrWhitespace 'hello'
# True
```

### example 2

```powershell
Test-NotNullOrWhitespace '  '
# False
```
