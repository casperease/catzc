---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md
    kind: comment-page
    body_sha: "2e6c5ab811b3"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#9
      - ADR-AZ-CUSTOMER#3
      - ADR-CONF-LOADING#4
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
---

# automation/Catzc.Base.Docs/types/AdrsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
adrs.yml — the ADR domain-structure registry (RULES ↔ domains wiring). Constructing an instance MAPS and
VALIDATES the parsed YAML (throwing with every violation collected) and exposes the typed Domains, the
flattened RuleSets, and the domain dependency Edges (AdrDomainEdge, one per depends_on link). Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AdrsConfig)
so Get-Config -Config adrs returns this typed model rather than a slippery ordered dictionary
([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4),
[ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

Load-time rules (self-contained — no filesystem or other-config reads; folder↔domain and terminology-token
cross-checks are the quality gate Test-AdrRegistry and shipped-asset integrity tests, mirroring the one-directional coupling of the customer
model, [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)):
  - domains is a non-empty map; each domain has code (^[A-Z]{2,4}$, optionally a compound of two segments
    like FLOW-CD), a non-empty role, a non-empty description, a depends_on list, and a non-empty rulesets map;
  - every depends_on target resolves to a declared domain, no self-edge, and the domain graph is acyclic;
  - each ruleset external is ADR-<code>[-<NAME>…] (^ADR-[A-Z]{2,4}(-[A-Z]+)+$), the leaf code (if any)
    matches the domain-code pattern, and the EFFECTIVE code (leaf override else domain code) is the
    external's domain segment — the external is 'ADR-<effective>' or begins 'ADR-<effective>-' (so a
    compound-code domain cites its root ADR as [ADR-FLOW-CD](/docs/adr/flow/cd-discipline-and-promotion-flow.md) and the rest as
[ADR-FLOW-CD](/docs/adr/flow/cd-discipline-and-promotion-flow.md)-<NAME>); every
    external is unique;
  - each domain declares its row of the value-chain stack (stack: one of Stacks,
    [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)) and its default value-chain concerns
    (concern: a list of one or more of Concerns); a ruleset may override the default with its own concern list, so
    every ADR resolves to at least one value-chain concern
    ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)). The allowed rows and concerns are
    declared once, here, in value-chain order
    ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6));
  - a domain or ruleset key outside the declared keys is rejected, so a misspelled key never falls back to a default.
```

## comment:2

Above `public static readonly IReadOnlyList<string> Concerns =...`.

```text
The value-chain concerns, in value-chain order, left to right
([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)).
```

## comment:3

Above `string expectedPrefix = "ADR-" + effective;`.

```text
The external's domain segment is the effective code: the external is either the
domain-root citation 'ADR-<effective>' or a named 'ADR-<effective>-<NAME>'. A compound
domain code (e.g. FLOW-CD, whose ADRs cite [ADR-FLOW-CD](/docs/adr/flow/cd-discipline-and-promotion-flow.md) and
[ADR-FLOW-CD](/docs/adr/flow/cd-discipline-and-promotion-flow.md)-<NAME>) is matched
by this prefix rule without splitting on a specific dash.
```
