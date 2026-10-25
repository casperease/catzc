# pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class BicepParamWriter`, written with `//`.

```text
Writes a slot's parameters as Bicep's own parameters format, in the layout `bicep format` leaves unchanged
(ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS): a `value` becomes a Bicep literal, a Key Vault `reference` becomes `az.getSecret(...)`.
```
