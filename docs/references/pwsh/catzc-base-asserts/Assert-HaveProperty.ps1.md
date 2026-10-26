# pwsh/Base.Asserts/Assert-HaveProperty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that an object has a named property, or a nested chain of properties.

### parameter `Object`

The object to inspect.

### parameter `PropertyName`

The property name that must exist on the object. Dotted paths (e.g. 'parent.child.etc.value') are walked level by level; the failure message
names the deepest segment that was reached before the chain broke.

### example 1

```powershell
Assert-HaveProperty $response 'StatusCode'
```

### example 2

```powershell
Assert-HaveProperty $config 'parent.child.etc.value'
```
