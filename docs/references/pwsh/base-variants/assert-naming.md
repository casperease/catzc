# pwsh/Base.Variants/Assert-Naming.ps1

The throwing guard over the `naming` variant: a caller that only works with one Azure resource-name preset states it here, and a repo
declaring anything else stops with a named error. `Test-Naming` is its query form.

## help

### synopsis

Asserts the repo's Azure resource-name naming (the `naming` variant) is the preset named, else throws.

### description

The throwing companion to Test-Naming. Pass exactly one of -Standard or -Classic; throws (naming the actual naming and where to change it)
when the repo's naming is not that preset. Guards a code path that only holds under one naming convention.

### parameter `Standard`

Require the 'standard' preset.

### parameter `Classic`

Require the 'classic' preset.

### example 1

```powershell
Assert-Naming -Standard
```
