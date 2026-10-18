# automation/Catzc.Base.Variants/Test-AdoNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the repo's Azure resource-name order (the `ado_naming` variant) is the one named.

### description

A predicate over the `ado_naming` repo-wide variant (see Get-AdoNaming). Pass exactly one of -Standard or -Classic; returns $true when the
repo's order matches. A guard callable anywhere above the Config layer; use Assert-AdoNaming to fail instead of branch.

### parameter Standard

Test for the 'standard' order (env/slot first, type last).

### parameter Classic

Test for the 'classic' order (type first, CAF-style).

### example 1

```powershell
if (Test-AdoNaming -Classic) { ... }
```
