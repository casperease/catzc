# pwsh/Base.Drs/types/DrsDomain.cs

One ADR domain, a `docs/drs/<area>/` folder, as `drs.yml` declares it. `DrsConfig` builds and validates it
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

## Properties

- `Name`, `Role`, and the reader-facing `Description` rendered under the domain's heading in the generated index.
- `Code` — the domain's code, null under a kind the domain owns
  ([ADR-REPO-DRSCODE-DOMAINSEGMENT](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment)).
- `DependsOn` — the links that form the domain DAG.
- `Stack` — its row of the value-chain stack ([DDR-TRACK-VALUECHAINSTACK](../../../../drs/design/tracks.md#rule-ddr-track-valuechainstack)).
- `Concerns` — its default value-chain concerns, in value-chain order
  ([DDR-TRACK-VALUECHAINCONCERN](../../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)).
- `RuleSets` — the rule sets it owns.
