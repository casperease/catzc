---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/drs,
      pwsh/Catzc.Base.Drs/configs/drs.yml,
      pwsh/Catzc.Base.Drs/types/DrsConfig.cs,
      docs/drs/repository/drs-code-language.md,
      pwsh/Catzc.Base.Docs/configs/glossary.yml,
    ]
---

# Decision Records System

The **Decision Records System (DRS)** is the one system that holds every decision record: the record-kind domains (`RDR`, `TDR`, `PDR`,
`WDR`, `DDR`, `FDR`, and the shared `ADR` of the implementation domains, together "XDR"), their rules, the index and the registry. Its home
is `docs/drs/`, and its commands and types live in `Catzc.Base.Drs`.

## Why its value is high

The prose still says "ADR" where it means any decision record: a reader who meets `docs/drs/principles/one-living-version.md` with a
`PDR-ONELIVE` code reads two names for one thing until the umbrella word is "decision record" and "ADR" names only the `ADR` kind.

## Decided (the user, 2026-10-21)

- The system is named **DRS**, the Decision Records System; it holds the XDR record-kind domains and their rules.
- The record kinds and their codes are unchanged: `ADR` stays the shared kind of the implementation domains.
- In prose, "decision record" names one record, "the DRS" the system, and "ADR" only the `ADR` kind; the sanctioned pair is "domain rules /
  DRS rules".

## Open steps

- [ ] `.claude/CLAUDE.md`, the user's edit: the structure line and the `## ADRs` section become `docs/drs/` and `## DRS`, "read
      `docs/drs/index.md`", "domain rules / DRS rules" (check: `Test-Links` on the file).
- [ ] The prose sweep's clear patterns (the user, 2026-10-21; counts in `out/drs/prep/renames-and-prose.md`): the section heading
      `## Where the code and the ADR differ` in the explanation pages becomes `## Where the code and the decision record differ`, with its
      anchors re-pointed; then the system words ("ADR index / registry / rules / domain" -> "DRS …"), the uses in framing-domain records (->
      the record's kind or "decision record") and the plurals meaning the corpus (-> "decision records"); the generated `index.md` and
      `glossary.md` through `drs-index.yml` and the `glossary.yml` sources; the implementation-domain self-references stay, as they name the
      `ADR` kind (check: `Test-Links` after the heading pass, then `Test-Terminology`, `Test-Glossary`, `Test-Links`).
- [ ] The singular uses of "ADR" outside the records (explanation, how-to, the glossary sources), after the clear patterns, one domain per
      step, each line read before its edit; the proposals are in `out/drs/prep/prose-381.md` (293 uses: 115 take the record's kind, 76 stay
      `ADR`, 40 become "decision record", 62 are the clear patterns' system words) (check: per domain, `Test-Terminology`, `Test-Glossary`
      and `Test-Links`).
