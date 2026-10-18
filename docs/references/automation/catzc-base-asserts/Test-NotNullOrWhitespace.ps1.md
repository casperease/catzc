# automation/Catzc.Base.Asserts/Test-NotNullOrWhitespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
