# pwsh/Catzc.Base.QualityGates/configs/links.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `wrap: break`, written with `#`.

```text
Link alignment settings for Format-Links / Test-Links ([ADR-REPO-LINK-ALIGNEDBYTOOL](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.QualityGates.LinksConfig
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and a Format-Links parameter overrides the
resolved value per call ([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/adr/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
```

## comment:2

Above `wrap: break`, written with `#`.

```text
How an aligned comment line that outgrows its limit is wrapped: break (continue the comment on a new line
before the link, never inside it) or off (leave it long and report it). Default: break.
```

## comment:3

Above `line_limit: {}`, written with `#`.

```text
Per-extension line-limit overrides, e.g. { .ps1: 120 }. Default: none — the repository's .editorconfig
max_line_length decides, so the limit is not stated twice.
```

## comment:4

Above `string_citations:`, written with `#`.

```text
The string-citation check: a rule citation in a code string literal is spelled ADR-<CODE>#<n>, never with a ':'
outside a '### Rule' heading ([ADR-REPO-LINK-ONECITATIONSPELLING](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)).
  mode    gate (default: every finding fails Test-Links) or report (findings are listed and never fail it)
  exempt  glob -> why its files may spell the ':' form on purpose; default none
```
