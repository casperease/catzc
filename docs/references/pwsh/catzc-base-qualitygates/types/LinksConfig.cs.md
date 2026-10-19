# automation/pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The link-alignment settings (configs/links.yml,
[ADR-REPO-LINK-ALIGNEDBYTOOL](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)), and the single declaration of their sensible
defaults: every key is optional, and an omitted key — or a fresh checkout with no file — behaves exactly like
the default, so no function restates a value
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A Format-Links parameter overrides the
resolved value per call ([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/adr/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
  wrap               — how an aligned comment line that outgrows its limit is wrapped (break | off; default break)
  line_limit         — per-extension limit overrides ({ .ps1: 120 }); default none, so .editorconfig decides
  default_line_limit — the limit for an extension .editorconfig gives no max_line_length (default 140, the
                       repository's prose target)
  string_citations   — the check that a rule citation in a code string literal is spelled ADR-<CODE>#<n>, never with
                       a ':' outside a '### Rule' heading
                       ([ADR-REPO-LINK-ONECITATIONSPELLING](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)): its mode
                       and exempt globs (a SourceCheck; default gate, nothing exempt)
Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).
```
