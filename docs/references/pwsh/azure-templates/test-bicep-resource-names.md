# pwsh/Azure.Templates/Test-BicepResourceNames.ps1

The gate that checks every resource name a template slot declares against the canonical form: each name is written in full in the slot yml,
and a name that does not match is an issue.

## help

### synopsis

Lists every declared name in a template's slots that does not match the canonical form, and reports the names checked, the exceptions and
the foreign names.

### description

Reads each slot yml of the template and collects its names: every string leaf, at any depth, under a parameter whose key ends in `Name` or
`Names`; the slot's top-level `ResourceGroup` key; and the resource-group and resource-name segments of an Azure resource ID anywhere in the
slot. Each name is matched against the canonical form (ADR-AZ-NAMING-DETERMINISTICNAMES). The match renders candidates from the known
environments, customers, template `short_name` values, slots, type abbreviations and the org through the one renderer, under the configured
`naming` order, and takes the leftover as the role, which must match `^[a-z][a-z0-9]{1,2}$`. A name is matched, never parsed:

- Exactly one match is a pass, and returns the components.
- No match is an issue with a diagnosis per part.
- More than one match is an ambiguity issue, in practice a `short_name` collision.

Beyond the match, the gate checks that:

- a name's environment, customer and slot equal those of its file, and its `short_name` that of its template;
- a name owned by another template carries that template's `short_name`, and the owner has a slot at those coordinates;
- the keys of `networkSecurityGroupNames` equal the subscription's subnets in network.yml minus its `no_nsg_subnets`.

A parameter keeps a non-canonical name only with `naming_exception: <reason>` beside its `value` (ADR-AZ-NAMING-EXCEPTIONENTRY). The gate
counts and lists every exception, and the build drops the entry from the rendered parameters.

The gate reports three facts: Names (the names checked), Exceptions and Foreign (the names another template owns).

### parameter `Template`

The templates to check. Defaults to every shipped template.

### parameter `OutputFolder`

Where the gate report is written. Defaults to the shared report folder.

### parameter `PassThru`

Return the gate result instead of throwing on issues.

### example 1

```powershell
Test-BicepResourceNames -PassThru
```
