# automation/Catzc.Base.Asserts/Test-HaveProperty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether an object has a specific property, or a nested chain of properties.

### parameter Object

The object to inspect.

### parameter PropertyName

The property name to look for. Dotted paths (e.g. 'parent.child.value') walk each level in turn; a missing or null-valued intermediate
short-circuits to $false rather than throwing.

### example 1

```powershell
Test-HaveProperty $object 'Name'
```

### example 2

```powershell
Test-HaveProperty $config 'parent.child.etc.value'
```
