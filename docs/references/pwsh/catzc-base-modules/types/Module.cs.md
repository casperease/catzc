# pwsh/Base.Modules/types/Module.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class Module`, written with `//`.

```text
A module of a deployable track as the one resolver returns it: identity only. Its needs and its place in the order are functions of
the declared graph over module names, not members of this type.
```

## comment:2

Above `public sealed class Module`, written with `//`.

```text
Rests on [ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](/docs/drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule) and [ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel).
```
