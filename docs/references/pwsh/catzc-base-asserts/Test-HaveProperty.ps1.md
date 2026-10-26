# pwsh/Base.Asserts/Test-HaveProperty.ps1

The query form that answers whether an object has a property or a dotted chain of properties; `Assert-HaveProperty` is its throwing form.

## help

### synopsis

Tests whether an object has a specific property, or a nested chain of properties.

### parameter `Object`

The object to inspect.

### parameter `PropertyName`

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
