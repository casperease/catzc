# pwsh/Azure.Templates/Get-BicepTemplate.ps1

The function that returns the descriptor of a single bicep template by name.

## help

### synopsis

Returns the descriptor for a single bicep template by name.

### parameter `Name`

Template name (the folder name under infrastructure/templates/).

### example 1

```powershell
$t = Get-BicepTemplate sample
$t.main
$t.environments
```

## The parenthesised call

The `Get-BicepTemplates` call is parenthesised so its comma-wrapped, array-preserving output is collected and then enumerated element by
element into `Where-Object`. A bare `Get-BicepTemplates | Where-Object` feeds the whole array as a single pipeline object, which silently
matches through member enumeration and returns every template. That stays latent until a second template exists.
