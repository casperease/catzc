# pwsh/Base.QualityGates/types/LinksConfig.cs

The typed record for `configs/links.yml`, the link-alignment settings
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)), and the single declaration
of their sensible defaults. Every key is optional, and an omitted key, or a fresh checkout with no file, behaves exactly like the default,
so no function restates a value
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A
`Format-Links` parameter overrides the resolved value per call
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)). Property names
mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

An unknown key throws.

- **`wrap`** — how an aligned comment line that outgrows its limit is wrapped: `break` or `off`, default `break` (`LinkWrap`).
- **`line_limit`** — per-extension limit overrides (`{ .ps1: 120 }`); default none, so `.editorconfig` decides.
- **`default_line_limit`** — the limit for an extension `.editorconfig` gives no `max_line_length`; default 140, the repository's prose
  target.
- **`string_citations`** — the check that a rule citation in a code string literal is spelled `ADR-<CODE>#<n>`, never with a `:` outside a
  `### Rule` heading
  ([ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)). It is a
  `SourceCheck`: its mode and exempt globs, default gate with nothing exempt.
