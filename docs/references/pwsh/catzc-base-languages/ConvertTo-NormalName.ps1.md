# pwsh/Base.Languages/ConvertTo-NormalName.ps1

`ConvertTo-NormalName` returns the repository normal form of a name written in a language's idiom. It is the inverse of
`ConvertFrom-NormalName`, and both read the language's `naming:` entry in `languages.yml`.

## help

### synopsis

Returns the repository normal form of a name written in a language's idiom.

### description

The name is split into its words by the first of the language's naming cases for the kind that it is in, and joined in the configured normal
form, `naming_normal_form` of the languages config
([ADR-AUTO-IDIOM-NORMALFORM](../../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-normalform)). A dotted name keeps its namespace
segments, joined by `.`. A name in none of the language's cases, and a language whose `naming:` names no case for the kind, are errors.

### parameter `Name`

The name in the language's idiom; from the pipeline, each name is converted in turn.

### parameter `Language`

The language whose `naming:` entry gives the cases the name may be in.

### parameter `NameKind`

Which of the language's naming cases apply: `function` (the default), `type`, `file` or `folder`.

### outputs

`[string]` The name in the repository normal form.

### example 1

```powershell
ConvertTo-NormalName 'Get-CommandContract' -Language powershell   # -> get_command_contract
```

### example 2

```powershell
ConvertTo-NormalName 'Catzc.Base.Contracts' -Language powershell -NameKind folder   # -> catzc.base.contracts
```
