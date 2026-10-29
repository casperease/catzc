# pwsh/Base.Variants/Test-Naming.ps1

The query form of the `naming` guard: it answers whether the repo's Azure resource-name naming is the preset named, and `Assert-Naming`
throws on the same answer.

## help

### synopsis

Tests whether the repo's Azure resource-name naming (the `naming` variant) is the preset named.

### description

A predicate over the `naming` repo-wide variant (see Get-Naming). Pass exactly one of -Standard or -Classic; returns $true when the repo
declares that preset. An explicit segment list matches neither. A guard callable anywhere above the Config layer; use Assert-Naming to fail
instead of branch.

### parameter `Standard`

Test for the 'standard' preset (env/slot first, type last).

### parameter `Classic`

Test for the 'classic' preset (type first, CAF-style).

### example 1

```powershell
if (Test-Naming -Classic) { ... }
```
