# pwsh/Catzc.Base.Variants/types/VariantsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The repo-wide variants (configs/variants.yml, [ADR-REPO-VARIANT](/docs/drs/repository/repo-variants.md)) —
settings fixed for the importer session. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Variants.VariantsConfig), so Get-Config -Config variants returns this typed record; the
private Get-Variant reads one key off it and the named primitives (Get-AdoNaming, Get-EnabledCustomers,
Get-Aspect, …) default an absent key. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); an absent key is null,
so the record's Contains(key) answers "is it set".

Constructing an instance validates the file, collecting every violation into one ArgumentException. Every key is
optional, and an unknown key throws (a typo fails fast at load):
  ado_naming      'standard' | 'classic' (the keys of Get-AzureNameOrderSet, mirrored as literals because this
                  Base type must not depend up into the Azure/Templates layer)
  git_workspace   'main-direct' | 'main-via-pr'
  have_customers  a boolean (false = none, true = all), the literal 'all', or a list of unique customer-name
                  tokens (^[a-z][a-z0-9]+$; empty = none). Not cross-checked against customer.yml (one layer up,
                  in Catzc.Azure) — an Azure-layer integrity test confirms every listed name is a customer.
  aspects         a non-empty map of track -> ordered list of single-key {name: [patterns]} entries
                  ([DDR-ASPECT](/docs/drs/design/module-aspects.md)): kebab-case unique names, non-empty
                  patterns, the LAST entry the bare '**' catch-all remainder and no earlier entry using it. The
                  catch-all's liveness is the container's call, and glob syntax is the Globs aspect engine's
                  check — structural checks only.
  tracks          a non-empty map of track -> { root, class, languages } ([DDR-TRACK](/docs/drs/design/tracks.md)),
                  in declared order: a kebab-case or dot-prefixed track name; 'root' required, one folder segment
                  (no '/', '\', '.' or '..'), never 'out' (gitignored output,
                  [DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)), and unique across tracks;
                  'class' required, one of VariantTrack.Classes
                  ([DDR-TRACK-ONETRACKTYPE](/docs/drs/design/tracks.md#rule-ddr-track-onetracktype)); 'languages' optional
                  (default: none), a list of unique kebab-case file-language names. This file is validated alone:
                  that each name is a registered file language is an integrity test in Catzc.Base.Languages.
```

## comment:2

Above `public object have_customers { get; }`, written with `//`.

```text
The enabled-customer set as written: a bool, the string 'all', or a string[] of customer names. Null when
unset. Get-EnabledCustomers is its single interpreter.
```

## comment:3

Above `public const string DefaultAdoNaming = "standard";`, written with `//`.

```text
The defaults, declared once here and nowhere else
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): a getter reads the typed property and never
restates them.
```
