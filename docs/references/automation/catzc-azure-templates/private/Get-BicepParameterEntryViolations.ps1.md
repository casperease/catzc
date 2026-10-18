# automation/Catzc.Azure.Templates/private/Get-BicepParameterEntryViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the violations of one parameters-file entry against its declaration in the template's compiled main.json.

### description

The per-entry check behind Get-BicepParameterViolations. An entry is the object a parameters file holds under `parameters.<name>`: either
`{ "value": … }` or an ARM Key Vault reference `{ "reference": { "keyVault": { "id": … }, "secretName": … } }`. Returns zero or more
messages, each the text that follows "parameter '`<name>`' " in the caller's message:

- an entry that sets both a value and a reference, or neither;
- a Key Vault reference that is not well-formed (a keyVault.id of the `/subscriptions/…/providers/Microsoft.KeyVault/vaults/…` shape and a
  non-empty secretName);
- a secureString/secureObject parameter set to a literal value — such a parameter takes only a Key Vault reference, and the message never
  includes the value;
- a value whose JSON type does not match the declared type (null is allowed only for a nullable parameter);
- a value outside the @allowed list (each element, for an array), compared case-insensitively for strings;
- an int outside @minValue/@maxValue, or a string or array whose length is outside @minLength/@maxLength.

A reference is resolved only at deploy time, so it is checked for its shape alone, whatever the declared type.

### parameter `Parameter`

The parameter's declaration, from Get-BicepParameterModel.

### parameter `Entry`

The parameters-file entry for that parameter.

### outputs

`[string[]]` the violations; empty when the entry conforms.

## comment:1

Above `if ($Parameter.IsSecure) {`, written with `#`.

```text
A secure parameter takes its value from a Key Vault at deploy time. A literal is a secret in the repository;
say so without ever echoing it.
```
