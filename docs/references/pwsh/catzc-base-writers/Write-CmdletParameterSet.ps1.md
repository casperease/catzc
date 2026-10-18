# pwsh/Catzc.Base.Writers/Write-CmdletParameterSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes all bound parameters of the calling function to the console.

### description

Pass $MyInvocation as the first argument at the top of a function to display all parameters that were actually bound. Sensitive parameters
can be masked by listing their names in -HiddenKeys.

### parameter `Invocation`

The $MyInvocation from the calling function.

### parameter `HiddenKeys`

Parameter names whose values should be masked as 'Hidden'.

### parameter `ForegroundColor`

Color for the output. Defaults to Green.

### example 1

```powershell
function Deploy-App {
    param($Environment, $Token)
    Write-CmdletParameterSet $MyInvocation -HiddenKeys 'Token'
    # ...
}
```
