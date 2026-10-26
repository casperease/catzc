# pwsh/Base.Languages/ConvertFrom-NormalName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders a repository normal-form name in a language's idiom.

### description

The name is split into its words by the configured normal form, `naming_normal_form` of the languages config, and joined in one of the
language's naming cases for the kind, so it is the inverse of ConvertTo-NormalName
([ADR-AUTO-IDIOM-ROUNDTRIP](../../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-roundtrip)). The case is the one named, else the
language's first case for the kind
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)). A name not in the
normal form, a case the language does not configure for the kind, and words a case cannot join (a `verb-noun` name whose words start with no
approved verb) are errors.

### parameter `Name`

The name in the repository normal form; from the pipeline, each name is rendered in turn.

### parameter `Language`

The language whose `naming:` entry gives the cases the name may be rendered in.

### parameter `NameKind`

Which of the language's naming cases apply: `function` (the default), `type`, `file` or `folder`.

### parameter `Case`

One of the language's cases for the kind to render in; without it, the first of them.

### outputs

`[string]` The name in the language's idiom.

### example 1

```powershell
ConvertFrom-NormalName 'get_command_contract' -Language powershell   # -> Get-CommandContract
```

### example 2

```powershell
ConvertFrom-NormalName 'catzc.base.contracts' -Language powershell -NameKind folder   # -> Catzc.Base.Contracts
```
