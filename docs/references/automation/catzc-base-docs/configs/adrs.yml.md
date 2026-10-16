---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/configs/adrs.yml.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "96d4a2de82c7"
    adrs:
      - ADR-DSGN-TRACK#{14,15}
---

# automation/Catzc.Base.Docs/configs/adrs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `domains:`, written with `#`.

```text
adrs.yml — the AUTHORED source of the ADR domain structure (RULES ↔ domains wiring).

Single source of truth for how the decision space is organised and cited. It declares:
  domains:  one per docs/adr/<area>/ folder — the unit the dependency graph connects. Each carries a
            `code` (2-4 letter DEFAULT domain code that composes the citation ADR-<code>-<NAME>), a `role`
            (its function in the system), a `description` (the reader-facing paragraph rendered under the
            domain's heading in index.md), and `depends_on` (the acyclic domain DAG, rendered via
            Get-AdrDomainEdges | ConvertTo-AdrDomainDiagram, mirroring the module dependency graph). Each also
            declares its row of the value-chain stack (`stack`: PRIN, DSGN, AUTO, PIPE, or CLOUD) and its default
            value-chain concerns (`concern`: a list of automation, build, quality-control, release, deploy, access),
            [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14) and
            [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15).
  rulesets: within a domain, keyed by INTERNAL kebab name (= the ADR file slug). Each declares its full
            EXTERNAL citation code (`ADR-<DC>-<NAME>`, fully spelled) and, when the code body is a
            registered spelling token, its `terminology` link into the `adr:` category of terminology.yml.
            `code` may be set on a LEAF to OVERRIDE the domain default; the validator asserts the external's
            DC-segment equals the effective code (`^[A-Z]{2,4}$`). `concern` may be set on a LEAF to OVERRIDE
            the domain default, only when the ADR's place in the value chain differs from its domain's.

Loaded via Get-Config -Config adrs; validated by its config type, AdrsConfig. index.md is a generated projection of
this file (Build-AdrIndex) — see [ADR-REPO-README](/docs/adr/repository/generated-readmes.md) pattern.
```

## comment:2

Above `code: FLOW-CD`, written with `#`.

```text
compound domain code — the root ADR cites [ADR-FLOW-CD](/docs/adr/flow/cd-discipline-and-promotion-flow.md), the
rest `ADR-FLOW-CD-<NAME>`
```

## comment:3

Above `reliability: { external: ADR-AZ-WAFRE, terminology: wafre }`, written with `#`.

```text
Vendor recommendation, one rule per vendor item: the Well-Architected Framework pillars (azure/waf/) and the Cloud Adoption
Framework landing-zone design areas (azure/caf/), each citing Microsoft's page and summarising it in our words.
```
