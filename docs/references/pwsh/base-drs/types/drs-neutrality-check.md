# pwsh/Base.Drs/types/DrsNeutralityCheck.cs

The settings of the engine-neutrality check (`configs/drs-checks.yml`, `engine_neutrality`), read by `Test-DrsEngineNeutrality`: the rule
summaries of each ADR domain it lists carry none of the tokens of the sets it names for that domain — engine syntax, vendor names, or both
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). `DrsChecksConfig`
builds and validates it.

## Keys

It mirrors the YAML mapping, so its properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

- **`mode`** — `report` or `gate`. The default is `CheckMode`'s default, `gate`.
- **`domains`** — a map of `drs.yml` domain to the list of token sets its rule summaries are held to. The default is none.
- **`token_sets`** — a map of set name (kebab-case) to a map of token name (kebab-case) to a case-sensitive .NET regular expression. The
  default is none.

`TokensFor(domain)` returns every token of a domain's sets, in the domain's set order and then file order; a domain not listed gets none.

## Why it is shaped so

A tier is held to the sets that fit it: an engine-neutral tier to engine syntax, a vendor-neutral tier to vendor names, a framing tier to
both. Bringing a tier under the gate is one `domains` line, and a token is declared once in its set however many tiers use it. A set a
domain names must be declared, which is a load-time rule; whether each domain is declared in `drs.yml` is the check's own finding, because
this type reads no other config.
