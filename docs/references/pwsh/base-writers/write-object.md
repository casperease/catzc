# pwsh/Base.Writers/Write-Object.ps1

The writer that pretty-prints any object, with its type and size, in a form that fits the object's shape.

## help

### synopsis

Pretty-prints any object to the console with type info and smart formatting.

### description

Renders objects differently based on their type:

- Simple values (string, number, bool): displayed directly
- Hashtables and ordered dictionaries: key = value pairs
- Collections/arrays: listed as items, or YAML if elements are complex
- PSCustomObject and other complex types: YAML

First line always shows the type name and size where relevant.

Suppressed during Pester test runs (like Write-Message) to keep test output clean.

### parameter `Object`

The object to display. Accepts pipeline input.

### parameter `Name`

Optional label displayed above the output.

### parameter `NoHeader`

Suppress the type info line and name label. Only the rendered value is shown.

### parameter `Depth`

Maximum recursion depth for nested objects. Defaults to 10.

### parameter `ForegroundColor`

Color for the output. Defaults to DarkGray.

### example 1

```powershell
Get-Process | Select-Object Name, Id, CPU -First 3 | Write-Object
```

### example 2

```powershell
$config | Write-Object -Name 'App config'
```

### example 3

```powershell
@{ a = 1; b = 2 } | Write-Object
```
