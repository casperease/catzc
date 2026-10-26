# pwsh/Base.Contracts/private/Assert-AccostedArgument.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Throws when an accosted call's argument does not fit its contract parameter.

### description

cats passes one value per parameter, so a list is rejected. The value must fit the parameter's type: a string, an integer, or a boolean for
a bool or switch parameter; any other type fits nothing ([ADR-AUTO-ACCOSTED](../../../../drs/automation/accosted-language.md)). What makes a
call harmless is not decided here.

### parameter `Parameter`

The contract parameter the argument is given for.

### parameter `Value`

The argument's value as the accosted file gives it.

### parameter `Where`

The run and command the argument sits in, leading each error.

### parameter `Signature`

The command's contract signature, closing each error.

### outputs

None; throws on the first rule the argument breaks.

### example 1

```powershell
Assert-AccostedArgument -Parameter $widgetParameter -Value 'gadget' -Where 'widget.accosted.yml: run 1, command 1' -Signature $signature
```
