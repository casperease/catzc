# pwsh/Base.Asserts/Assert-HaveProperty.ps1

The throwing form of `Test-HaveProperty`: it throws when an object lacks a property or a dotted chain of properties.

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
