# pwsh/Base.Variants/Test-AdoNaming.ps1

The query form of the `ado_naming` guard: it answers whether the repo's Azure resource-name order is the one named, and `Assert-AdoNaming`
throws on the same answer.

## help

### synopsis

Tests whether the repo's Azure resource-name order (the `ado_naming` variant) is the one named.

### description

A predicate over the `ado_naming` repo-wide variant (see Get-AdoNaming). Pass exactly one of -Standard or -Classic; returns $true when the
repo's order matches. A guard callable anywhere above the Config layer; use Assert-AdoNaming to fail instead of branch.

### parameter `Standard`

Test for the 'standard' order (env/slot first, type last).

### parameter `Classic`

Test for the 'classic' order (type first, CAF-style).

### example 1

```powershell
if (Test-AdoNaming -Classic) { ... }
```
