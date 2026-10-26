# pwsh/Base.QualityGates/configs/links.yml

The settings for link alignment and the string-citation check, shared by Format-Links and Test-Links
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)).

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `Catzc.Base.QualityGates.LinksConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and a
Format-Links parameter overrides the resolved value per call
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).

- `wrap`: how an aligned comment line that outgrows its limit is wrapped. `break` continues the comment on a new line before the link, never
  inside it. `off` leaves it long and reports it. Default: `break`.
- `line_limit`: per-extension line-limit overrides, for example `{ .ps1: 120 }`. Default: none, so the repository's `.editorconfig`
  `max_line_length` decides and the limit is not stated twice.
- `default_line_limit`: the limit for an extension that `.editorconfig` gives no `max_line_length`. Default: 140, the prose target.
- `string_citations`: the string-citation check. A rule citation in a code string literal is spelled `ADR-<CODE>#<n>`, never with a `:`
  outside a `### Rule` heading
  ([ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)).
  - `mode`: `gate`, the default, where every finding fails Test-Links, or `report`, where findings are listed and never fail it.
  - `exempt`: a glob mapped to the reason its files may spell the `:` form on purpose. Default: none.
