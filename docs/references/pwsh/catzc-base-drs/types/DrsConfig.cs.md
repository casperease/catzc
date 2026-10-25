# pwsh/Catzc.Base.Drs/types/DrsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
drs.yml — the ADR domain-structure registry (RULES ↔ domains wiring). Constructing an instance MAPS and
VALIDATES the parsed YAML (throwing with every violation collected) and exposes the typed Domains, the
flattened RuleSets, and the domain dependency Edges (DrsDomainEdge, one per depends_on link). Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Drs.DrsConfig)
so Get-Config -Config drs returns this typed model rather than a slippery ordered dictionary
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype),
[ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

Load-time rules (self-contained — no filesystem or other-config reads; folder↔domain and terminology-token
cross-checks are the quality gate Test-DrsRegistry and shipped-asset integrity tests, mirroring the one-directional coupling of the customer
model, [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)):
  - domains is a non-empty map; each domain has code (^[A-Z]{2,4}$, optionally a compound of two segments
    like FLOW-CD), a non-empty role, a non-empty description, a depends_on list, and a non-empty rulesets map;
  - every depends_on target resolves to a declared domain, no self-edge, and the domain graph is acyclic;
  - each ruleset external is ADR-<NAME> or ADR-<code>-<NAME>… (^ADR-[A-Z]+(-[A-Z]+)*$, one or more uppercase
    segments), the leaf code (if any) matches the domain-code pattern, and when the external has a domain
    segment the EFFECTIVE code (leaf override else domain code) is that segment — the external is
    'ADR-<effective>' or begins 'ADR-<effective>-' (a one-segment external such as ADR-REPO-AI has none to match; so a
    compound-code domain cites its root ADR as [FDR-CD](/docs/drs/flow/cd-discipline-and-promotion-flow.md) and the rest as
[FDR-CD](/docs/drs/flow/cd-discipline-and-promotion-flow.md)-<NAME>); every
    external is unique;
  - each domain declares its row of the value-chain stack (stack: one of Stacks,
    [DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack)) and its default value-chain concerns
    (concern: a list of one or more of Concerns); a ruleset may override the default with its own concern list, so
    every ADR resolves to at least one value-chain concern
    ([DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern)). The allowed rows and concerns are
    declared once, here, in value-chain order
    ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder));
  - a domain or ruleset key outside the declared keys is rejected, so a misspelled key never falls back to a default.
```

## comment:2

Above `public static readonly IReadOnlyList<string> Concerns =...`, written with `//`.

```text
The value-chain concerns, in value-chain order, left to right
([DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern)).
```

## comment:3

Above `string expectedPrefix = effective == null ? domainKind : domainKind + "-" +...`, written with `//`.

```text
The external starts with its domain's prefix: the kind and the effective code under a shared kind, the kind alone under a kind one
domain owns. The external is either the domain-root citation '<kind>-<effective>' or a named '<kind>-<effective>-<NAME>'. A compound
domain code (e.g. FLOW-CD, whose ADRs cite [FDR-CD](/docs/drs/flow/cd-discipline-and-promotion-flow.md) and
[FDR-CD](/docs/drs/flow/cd-discipline-and-promotion-flow.md)-<NAME>) is matched
by this prefix rule without splitting on a specific dash. A one-segment external
('ADR-<NAME>', no dash after the prefix) carries no domain segment and skips the match.
```

## comment:4

Above `public const string DefaultKind = "ADR";`, written with `//`.

```text
The record kinds when drs.yml declares none: the one shared kind ADR
([ADR-REPO-DRSCODE-PATHOFSEGMENTS](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-pathofsegments)).
```

## comment:5

Above `public DrsCodeForm CodeForm { get; }`, written with `//`.

```text
The code grammar over these kinds, which every parser of a code reads
([ADR-REPO-DRSCODE-PATHOFSEGMENTS](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-pathofsegments)).
```

## comment:6

Above `string domainKind = d.Contains("kind") && d["kind"] != null ?...`, written with `//`.

```text
A shared kind's domains each add a code; a kind one domain owns stands for it, with no code
([ADR-REPO-DRSCODE-DOMAINSEGMENT](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment)).
```
