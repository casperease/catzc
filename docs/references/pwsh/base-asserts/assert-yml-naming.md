# pwsh/Base.Asserts/Assert-YmlNaming.ps1

The check that every key of a parsed YAML structure is snake_case, which keeps config keys mirrored one to one by the typed records.

## help

### synopsis

Validates that all property keys in a parsed YAML object use snake_case.

### description

Recursively walks a parsed YAML structure and asserts that every property key matches snake_case (lowercase letters, digits, underscores,
starting with a letter). List items and values are not checked.

### parameter `Yaml`

The parsed YAML object (from ConvertFrom-Yaml -Ordered).

### parameter `PropertyPath`

Optional root prefix for error messages. Useful when validating a subtree, e.g. Assert-YmlNaming $config.customers 'customers' will report
paths as 'customers.blue.details' instead of 'blue.details'.

### example 1

```powershell
$config = Get-Content config.yml -Raw | ConvertFrom-Yaml -Ordered
Assert-YmlNaming $config
```

### example 2

```powershell
Assert-YmlNaming $config.customers 'customers'
```
