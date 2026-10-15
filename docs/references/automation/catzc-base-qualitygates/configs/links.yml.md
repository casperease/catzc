---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/links.yml.md
    kind: comment-page
    body_sha: a0a7b9760742
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PWSH-PARAM#4
      - ADR-REPO-LINK#5
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/configs/links.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `wrap: break`.

```text
Link alignment settings for Format-Links / Test-Links ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.QualityGates.LinksConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and a Format-Links parameter overrides the
resolved value per call ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:2

Above `wrap: break`.

```text
How an aligned comment line that outgrows its limit is wrapped: break (continue the comment on a new line
before the link, never inside it) or off (leave it long and report it). Default: break.
```

## comment:3

Above `line_limit: {}`.

```text
Per-extension line-limit overrides, e.g. { .ps1: 120 }. Default: none — the repository's .editorconfig
max_line_length decides, so the limit is not stated twice.
```

## comment:4

Above `string_citations:`.

```text
The string-citation check: a rule citation in a code string literal is spelled ADR-<CODE>#<n>, never with a ':'
outside a '### Rule' heading ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)).
  mode    gate (default: every finding fails Test-Links) or report (findings are listed and never fail it)
  exempt  glob -> why its files may spell the ':' form on purpose; default none
```
