# automation/Catzc.Base.Variants/Assert-AdoNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
