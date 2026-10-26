# pwsh/Base.Drs/types/DrsConfig.cs

The typed record of `drs.yml`, the ADR domain-structure registry (the wiring of rules to domains). Constructing an instance maps and
validates the parsed YAML, throwing with every violation collected, and exposes the typed `Domains`, the flattened `RuleSets`, and the
domain dependency `Edges` (`DrsDomainEdge`, one per `depends_on` link).

## Registration

It is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config drs` returns this typed model rather than a slippery
ordered dictionary
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype),
[ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

## Keys

The top level takes `root`, `kinds`, `domains` and `domain_classes`. A domain takes `kind`, `code`, `role`, `description`, `depends_on`,
`stack`, `concern`, `folder` and `rulesets`. A rule set takes `external`, `code`, `concern` and `layer`. A key outside these is rejected, so
a misspelled key never falls back to a default.

## Load-time rules

The rules are self-contained: no filesystem or other-config reads. The folder-to-domain and terminology-token cross-checks belong to the
quality gate `Test-DrsRegistry` and to shipped-asset integrity tests, which mirrors the one-directional coupling of the customer model
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).

- `domains` is a non-empty map. Each domain has a role, a description, a `depends_on` list and a non-empty `rulesets` map.
- Every `depends_on` target resolves to a domain the file declares, there is no self-edge, and the graph of domains is acyclic.
- Every `external` is unique and matches the code grammar. When the external has a domain segment, the effective code (the rule set's
  override, else the domain's code) is that segment. A one-segment external such as `ADR-REPO-AI` has none to match.
- Each domain declares its row of the value-chain stack (`stack`, one of `Stacks`,
  [DDR-TRACK-VALUECHAINSTACK](../../../../drs/design/tracks.md#rule-ddr-track-valuechainstack)) and its default value-chain concerns
  (`concern`, a list of one or more of `Concerns`). A rule set may override the default with its own `concern` list, so every ADR resolves
  to at least one concern ([DDR-TRACK-VALUECHAINCONCERN](../../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)). The allowed
  rows and concerns are declared once, in value-chain order
  ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Domain prefix

The external starts with its domain's prefix: the kind and the effective code under a shared kind, the kind alone under a kind one domain
owns. The external is either the domain-root citation `<kind>-<effective>` or a named `<kind>-<effective>-<NAME>`. A compound code of a
domain, such as `FLOW-CD`, is matched by this prefix rule without splitting on a specific dash. A one-segment external has no dash after the
prefix, carries no domain segment and skips the match.

## Kinds

When `drs.yml` declares no kinds, the record kind is the one shared kind `ADR`
([ADR-REPO-DRSCODE-PATHOFSEGMENTS](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-pathofsegments)). A shared kind's
domains each add a code. A kind one domain owns stands for it, with no code
([ADR-REPO-DRSCODE-DOMAINSEGMENT](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment)). `CodeForm` is the
code grammar over these kinds, which every parser of a code reads.

## Concerns

`Concerns` lists the value-chain concerns in value-chain order, left to right.
