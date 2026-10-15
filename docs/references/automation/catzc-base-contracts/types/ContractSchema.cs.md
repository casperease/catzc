---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractSchema.cs.md
    kind: comment-page
    body_sha: "3afc2d46d2ba"
    adrs:
      - ADR-PWSH-TYPES#1
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/types/ContractSchema.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The schema check of a contract asset ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
a value — a real file or a sample payload, parsed (ContractValue is the value model) — validates against a JSON Schema.
The BCL carries no JSON Schema validator and no package may be added
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)), so this is a bounded subset,
and it says so: a schema is an object or a boolean (true admits every value, false none), and its keywords are
  type                  a JSON type name, or an array of them: null, boolean, object, array, number, string, integer
                        (an integer is a number too)
  required              an array of property names the object must hold
  properties            an object of property name to schema; each property the object holds validates against its own
  additionalProperties  true or false only; false admits no property that properties does not name
  enum                  an array; the value equals one of its elements (ContractValue.Equal)
  items                 one schema every array element validates against (the array form is not supported)
  const                 the value equals it
The annotation keywords $schema, $id, $comment, title, description and examples are explicit no-ops: each is read
and ignored by name, in any form, and never constrains a value. Every other keyword is a finding "unsupported
keyword", never ignored, and so is a keyword of the subset in a form it does not support. The schema is read whole
first, every nested schema under properties and items included, whatever the value holds; a value is validated only
against a schema with no such finding, since a schema the subset cannot read whole cannot say what it admits.

Inspect returns the schema's own findings alone (for a schema whose instance another check validates); Validate
returns those, or else the value's findings, one precise message per violation, and an empty list when the value
validates. A schema location is a JSON Pointer from # (#/properties/name); a value location is JSONPath ($.name).
```
