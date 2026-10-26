# pwsh/Base.Variants/Assert-AdoNaming.ps1

The throwing guard over the `ado_naming` variant: a caller that only works with one Azure resource-name order states it here, and a repo
declaring the other order stops with a named error. `Test-AdoNaming` is its query form.

## help

### synopsis

Asserts the repo's Azure resource-name order (the `ado_naming` variant) is the one named, else throws.

### description

The throwing companion to Test-AdoNaming. Pass exactly one of -Standard or -Classic; throws (naming the actual order and where to change it)
when the repo's order does not match. Guards a code path that only holds under one naming convention.

### parameter `Standard`

Require the 'standard' order.

### parameter `Classic`

Require the 'classic' order.

### example 1

```powershell
Assert-AdoNaming -Standard
```
