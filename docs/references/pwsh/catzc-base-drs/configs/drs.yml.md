# pwsh/Base.Drs/configs/drs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `domains:`, written with `#`.

```text
drs.yml — the AUTHORED source of the ADR domain structure (RULES ↔ domains wiring).

Single source of truth for how the decision space is organised and cited. It declares:
  domains:  one per docs/drs/<area>/ folder — the unit the dependency graph connects. Each carries a
            `code` (2-4 letter DEFAULT domain code that composes the citation ADR-<code>-<NAME>), a `role`
            (its function in the system), a `description` (the reader-facing paragraph rendered under the
            domain's heading in index.md), and `depends_on` (the acyclic domain DAG, rendered via
            Get-DrsDomainEdges | ConvertTo-DrsDomainDiagram, mirroring the module dependency graph). Each also
            declares its row of the value-chain stack (`stack`: PRIN, DSGN, AUTO, PIPE, or CLOUD) and its default
            value-chain concerns (`concern`: a list of automation, build, quality-control, release, deploy, access),
            [DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack) and
            [DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern).
  rulesets: within a domain, keyed by INTERNAL kebab name (= the ADR file slug). Each declares its full
            EXTERNAL citation code (`ADR-<DC>-<NAME>`, or a one-segment `ADR-<NAME>` such as `ADR-REPO-AI`, fully
            spelled) and, when the code body is a registered spelling token, its `terminology` link into the
            `adr:` category of terminology.yml. `code` may be set on a LEAF to OVERRIDE the domain default; the
            validator asserts a two-segment external's DC-segment equals the effective code (`^[A-Z]{2,4}$`),
            and a one-segment external has no DC-segment to match. `concern` may be set on a LEAF to OVERRIDE
            the domain default, only when the ADR's place in the value chain differs from its domain's.

Loaded via Get-Config -Config drs; validated by its config type, DrsConfig. index.md is a generated projection of
this file (Build-DrsIndex) — see [ADR-REPO-README](/docs/drs/repository/generated-readmes.md) pattern.
```

## comment:2

Above `reliability: { external: ADR-AZ-WAF-RE }`, written with `#`.

```text
Vendor recommendation, one rule per vendor item: the Well-Architected Framework pillars (azure/waf/) and the Cloud Adoption
Framework landing-zone design areas (azure/caf/), each citing Microsoft's page and summarising it in our words.
```

## comment:3

Above `kinds:`, written with `#`.

```text
The record kinds, each a code's first segment (ADR-REPO-DRSCODE-PATHOFSEGMENTS): a shared kind's domains each add their code, a kind one
domain owns stands for it (ADR-REPO-DRSCODE-DOMAINSEGMENT).
```
