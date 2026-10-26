# pwsh/Base.Asserts/Assert-TypeIs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
