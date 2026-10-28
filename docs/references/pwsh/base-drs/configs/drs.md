# pwsh/Base.Drs/configs/drs.yml

The authored source of the DRS domain structure, the wiring of rules to domains, and the single source of truth for how the decision space
is organised and cited. `Get-Config -Config drs` loads it, and its config type `DrsConfig` validates it. `index.md` is a generated
projection of this file (`Build-DrsIndex`), see [ADR-REPO-README](../../../../drs/repository/generated-readmes.md).

## Domains

`domains` has one entry per `docs/drs/<area>/` folder, the unit the dependency graph connects. Each carries:

- `code` — the 2 to 4 letter default code of the domain that composes the citation `ADR-<code>-<NAME>`;
- `role` — its function in the system;
- `description` — the reader-facing paragraph rendered under the domain's heading in `index.md`;
- `depends_on` — the acyclic DAG of domains, rendered through `Get-DrsDomainEdges | ConvertTo-DrsDomainDiagram`, mirroring the module
  dependency graph;
- `stack` — its row of the value-chain stack: PRIN, DSGN, AUTO, PIPE or CLOUD
  ([ADR-REPO-VALUECHAIN-STACK](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-stack));
- `concern` — its default value-chain concerns, a list of automation, build, quality-control, release, deploy and access
  ([ADR-REPO-VALUECHAIN-CONCERN](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-concern)).

## Rule sets

Within a domain, `rulesets` is keyed by the internal kebab name, which is the record file slug. Each rule set declares:

- its full `external` citation code, `ADR-<DC>-<NAME>`, or a one-segment `ADR-<NAME>` such as `ADR-REPO-AI`, fully spelled;
- when the code body is a registered spelling token, its `terminology` link into the `rule-code:` category of `terminology.yml`;
- optionally a `code` on the leaf, which overrides the domain default. The validator asserts that a two-segment external's domain segment
  equals the effective code, and a one-segment external has no domain segment to match;
- optionally a `concern` on the leaf, which overrides the domain default only when the record's place in the value chain differs from its
  domain's.

## Vendor recommendations

The Azure domains hold one rule set per vendor item: the Well-Architected Framework pillars (`external/azure/waf/`) and the Cloud Adoption
Framework landing-zone design areas (`external/azure/caf/`), each citing Microsoft's page and summarising it in the repository's own words.

## Kinds

`kinds` lists the record kinds, each a code's first segment
([ADR-REPO-DRSCODE-PATHOFSEGMENTS](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-pathofsegments)). A shared kind's
domains each add their code. A kind one domain owns stands for it
([ADR-REPO-DRSCODE-DOMAINSEGMENT](../../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment)).
