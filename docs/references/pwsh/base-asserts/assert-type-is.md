# pwsh/Base.Asserts/Assert-TypeIs.ps1

The assertion that an object is of one expected .NET type, named by its full type name.

## help

### synopsis

Asserts that an object is a specific .NET type.

### parameter `Object`

The object whose type to check.

### parameter `TypeFullName`

The expected full type name (e.g. 'System.String').

### example 1

```powershell
Assert-TypeIs $value 'System.Int32'
```
