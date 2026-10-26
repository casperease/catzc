# pwsh/Azure.Templates/types/BicepParamWriter.cs

The static writer that renders a slot's parameters as Bicep's own parameters format, in the layout `bicep format` leaves unchanged
(ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS). A `value` becomes a Bicep literal, and a Key Vault `reference` becomes `az.getSecret(...)`.
