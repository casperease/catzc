# pwsh/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The parameter names Test-ParameterConsistency lets carry more than one type across the public functions
(configs/parameter-consistency.yml, [ADR-PWSH-PARAM](/docs/adr/automation/pwsh/parameter-design.md)), and the single declaration of
its sensible default ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)):
  exempt — parameter name (without the dash) -> why the same name means a different thing in different functions.
           Omitted: no parameter is exempt. A name is matched case-insensitively; every reason is non-empty.
Property names mirror the YAML keys (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
