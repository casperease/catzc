---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
    kind: comment-page
    body_sha: e7a24120f663
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-PWSH-PARAM#4
      - ADR-REPO-LINK#5
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/types/LinksConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The link-alignment settings (configs/links.yml,
[ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)), and the single declaration of their sensible
defaults: every key is optional, and an omitted key — or a fresh checkout with no file — behaves exactly like
the default, so no function restates a value
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). A Format-Links parameter overrides the
resolved value per call ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
  wrap               — how an aligned comment line that outgrows its limit is wrapped (break | off; default break)
  line_limit         — per-extension limit overrides ({ .ps1: 120 }); default none, so .editorconfig decides
  default_line_limit — the limit for an extension .editorconfig gives no max_line_length (default 140, the
                       repository's prose target)
  string_citations   — the check that a rule citation in a code string literal is spelled ADR-<CODE>#<n>, never with
                       a ':' outside a '### Rule' heading
                       ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)): its mode
                       and exempt globs (a SourceCheck; default gate, nothing exempt)
Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
