# pwsh/Base.Drs/types/DrsRuleSet.cs

One ADR rule set, an ADR, as `drs.yml` declares it. `DrsConfig` builds and validates it. It is a processed record, not a raw YAML mirror, so
its properties are PascalCase ([ADR-BCL-TYPES](../../../../drs/automation/BCL/native-csharp-types.md),
[ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

## Properties

- `Slug` — the internal kebab name.
- `External` — the full citation code, for example `ADR-<DC>-<NAME>`.
- `Code` — the effective domain code: a leaf override, else the domain default `DomainCode`.
- `Domain` and its `Role` — the folder-owning domain.
- `Terminology` — the optional terminology token.
- `Stack` — the domain's row of the value-chain stack.
- `Concerns` — the effective value-chain concerns: a rule set override, else the domain default `DomainConcerns`
  ([DDR-TRACK-VALUECHAINCONCERN](../../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)).
