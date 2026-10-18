# automation/Catzc.Azure.Templates/private/Get-BicepParameterViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns every violation of a template's rendered parameters files against its compiled parameter model.

### description

Reads the template's parameter model (Get-BicepParameterModel, which builds the template first when its output folder holds no current
build) and checks every `parameters.<config>.json` that Build-Bicep rendered into the same output folder. The rendered files are the configs
after the template's PrePost.psm1 prepare hook merged in its values, so a parameter the hook supplies counts as supplied. Per file it
reports:

- a parameter main.json does not declare;
- a required parameter (no default, not nullable) that the file does not supply;
- per supplied parameter, what Get-BicepParameterEntryViolations finds: a type mismatch, a value outside @allowed, a value or length out of
  bounds, a literal for a secure parameter, a malformed Key Vault reference.

A file that is not a JSON object with a `parameters` object is one violation.

Each message reads `<template>/<parameters file>: parameter '<name>' …` and never includes a secure parameter's value. Assert-BicepTemplate
-Build reports these, and the L2 integrity test Get-BicepParameterModel.Shipped.Tests.ps1 asserts that no shipped template has any.

### parameter Template

Template name (folder under infrastructure/templates/).

### outputs

`[string[]]` the violations; empty when every rendered parameters file conforms.
