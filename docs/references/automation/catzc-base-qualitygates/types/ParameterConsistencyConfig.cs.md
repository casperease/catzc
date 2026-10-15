---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
    kind: reference
    body_sha: c4a991178c2a
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The parameter names Test-ParameterConsistency lets carry more than one type across the public functions
(configs/parameter-consistency.yml, [ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md)), and the single declaration of
its sensible default ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
  exempt — parameter name (without the dash) -> why the same name means a different thing in different functions.
           Omitted: no parameter is exempt. A name is matched case-insensitively; every reason is non-empty.
Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
