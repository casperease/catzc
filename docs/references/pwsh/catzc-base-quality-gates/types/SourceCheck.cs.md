# pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The settings every source check shares, read from its key in a QualityGates config (links.yml's string_citations,
source-conventions.yml's engine_set and neutral_codes), and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)):
  mode   — gate (every finding fails the run; the default) or report (findings are printed and counted, and never
           fail it). A check is in report mode only while its work list is drained (Catzc.Base.Docs.CheckMode,
           whose zero value, Gate, is the one declared default, parsed by the one Catzc.Base.Docs.CheckModes parser).
  exempt — repository-relative glob (the durable-sha-globs dialect) -> why the files it matches are left out of the
           check. Omitted: no file is exempt. Every reason is non-empty: an exception is a declared entry with
           its reason, never a list in code
           ([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](/docs/drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)).
A check with settings of its own derives from this type and names its extra keys, so one key set is validated
in one place. Property names mirror the YAML keys (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
