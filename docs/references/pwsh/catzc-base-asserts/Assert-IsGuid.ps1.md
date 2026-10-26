# pwsh/Base.Asserts/Assert-IsGuid.ps1

The throwing form of `Test-IsGuid`: it throws when a string is not a valid GUID.

## help

### synopsis

Asserts that a string is a valid GUID.

### parameter `ObjectGuid`

The string to validate as a GUID.

### example 1

```powershell
Assert-IsGuid 'a55e0700-a000-601d-0000-000000000000'
```
