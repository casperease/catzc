# pwsh/Azure.Templates/Get-BicepParameterModel.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a template's Bicep parameter model, every parameter its compiled main.json declares with its type, default, allowed values and
bounds.

### description

Reads the `parameters` section of the main.json that Build-Bicep writes to the template's output folder (Get-BicepTemplatesOutputRoot) and
returns it as a `[Catzc.Azure.Templates.BicepParameterModel]`: the template name plus one `[Catzc.Azure.Templates.BicepParameter]` per
declared parameter, keyed by name.

When the output folder holds no current build, it runs Build-Bicep first, which also renders the `parameters.<config>.json` files. A build
is current when its main.json is at least as new as every input Build-Bicep reads from the template folder: the template's `*.bicep` files,
its configuration files, and its PrePost.psm1. A reusable module under infrastructure/modules/ is not among those inputs, so after editing
only a module run Build-Bicep yourself. The build is the only call to `az`; reading the model is pure over the JSON.

Get-BicepParameterViolations checks every rendered parameters file against this model.

### parameter `Template`

Template name (folder under infrastructure/templates/).

### outputs

`[Catzc.Azure.Templates.BicepParameterModel]`

### example 1

```powershell
(Get-BicepParameterModel foundation).Parameters.Values | Format-Table Name, Type, HasDefault, AllowedValues
```
