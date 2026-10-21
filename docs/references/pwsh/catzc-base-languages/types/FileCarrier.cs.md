# pwsh/Catzc.Base.Languages/types/FileCarrier.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The properties are snake_case because they mirror the YAML keys; FileCarriersConfig validates an entry and builds one.
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
```

## comment:2

Above `public string sidecar { get; }`, written with `//`.

```text
The path template of a sidecar carrier, where {base} is the file's path without its last extension and {stem} the middle part of
its name between the first and last "--" (the whole name without extensions when it has none); one folder level may be "*".
Null for any other carrier.
```
