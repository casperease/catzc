---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [docs/adr/repository/adr-code-language.md, pwsh/Catzc.Base.Docs/configs/adrs.yml, pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs]
---

# Record-kind codes

A code's first segment names its record kind. A kind one domain owns stands for that domain and drops its domain segment
(`ADR-DSGN-TRACK-UNORDEREDTRACK` is `DDR-TRACK-UNORDEREDTRACK`); `ADR` stays the shared kind of the implementation domains, which keep their
domain segment (`ADR-AUTO-DEFAULT-ONERESOLUTIONORDER` is unchanged).

## Why its value is high

The framing domains are cited about 3,800 times in about 960 files, each citation one segment longer than its fact needs, and the kind tells
a reader before opening the record whether it is a thesis, an axiom, a way of working, a design, a flow or an architecture decision.

## Decided (the user, 2026-10-21)

| Domain     | Today      | Kind                                   | Example                    |
| ---------- | ---------- | -------------------------------------- | -------------------------- |
| research   | `ADR-DORA` | `RDR-DORA` (Research Decision Record)  | `RDR-DORA-VCS`             |
| thesis     | `ADR-THES` | `TDR` (Thesis Decision Record)         | `TDR-ONETRUTH`             |
| principles | `ADR-PRIN` | `PDR` (Principle Decision Record)      | `PDR-ONELIVE`              |
| process    | `ADR-PROC` | `WDR` (Way-of-working Decision Record) | `WDR-KAIZEN`               |
| design     | `ADR-DSGN` | `DDR` (Design Decision Record)         | `DDR-TRACK-UNORDEREDTRACK` |
| flow       | `ADR-FLOW` | `FDR` (Flow Decision Record)           | `FDR-CD-RUNNER`            |
| the rest   | `ADR-<D>`  | `ADR` (Architecture Decision Record)   | unchanged                  |

- `RDR` keeps `DORA` as a group segment, as ADR-REPO-ADRCODE-ADRSEGMENT groups a vendor framework.
- `docs/adr/`, the `Adr*` commands and types, and the `adr` file names stay in this pass; "decision record" is the umbrella term in prose.
  Their rename is a later plan.

## Open steps

- [ ] ADR-REPO-ADRCODE: PATHOFSEGMENTS (the marker is a registered kind), DOMAINSEGMENT (a domain owns a kind or sits under `ADR` with its
      segment), CODEISSELECTOR (every record is the list of kinds), the index preamble in `adr-index.yml` (check: `Test-Links` on the page
      and `Test-AdrRegistry`).
- [ ] `adrs.yml` and `AdrsConfig.cs`: a `kind:` per domain, `code:` only under `ADR` (check: `Invoke-TestFile` on the `AdrsConfig` and
      `Build-AdrIndex` tests).
- [ ] The 30 parsers of the `ADR` marker read the kinds from the registry, `AdrCitationRewriter.cs` and `AdrCodeForm.cs` first, then one
      file at a time (list: `out/xdr-rename/parser-files.txt`); one widget fixture per new kind (check: each file's tests).
- [ ] The code map and rule map for `Update-AdrCitation`, one row per framing ADR and rule (check: `-DryRun` over the tree reports every
      code `git grep` finds).
- [ ] The rewrite, one domain per step, `-DryRun` first: the ADR pages (titles, `## Rules:`, `### Rule`), then every citer; derived heads
      regenerated with `Format-FileMeta`, `Build-AdrIndex` and `Build-AdrCodeDictionary` (check: `Test-Links`, `Test-AdrRegistry`,
      `Test-GeneratedFiles`).
- [ ] Prose wildcards (`ADR-DSGN-*`), diagram `diagram.drawio.yml` subtitles and legends re-rendered, `glossary.yml`, `agents.yml`,
      `capabilities.yml`, `.claude/CLAUDE.md`, by hand one file at a time (check: no `ADR-(THES|PRIN|PROC|DSGN|FLOW|DORA)` left outside the
      frozen release).
- [ ] `contracts/EXTERNAL-azure/0.1.0` keeps its old codes (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE): exempt it from the link check with its
      reason (check: `Test-Links`).
