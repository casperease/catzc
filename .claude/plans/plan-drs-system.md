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
      pwsh/Catzc.Base.Docs/configs/glossary,
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

- [ ] `.claude/CLAUDE.md`, the user's edit (its paths were already rewritten to `docs/drs` by the move): line 31 `## ADRs` becomes `## DRS`,
      line 33's "Architecture Decision Records live under …" says the DRS holds the decision records, and line 13's sanctioned pair becomes
      "domain rules / DRS rules" (check: `Test-Links` on the file).
- [ ] `docs/drs/` page of `Update-DrsCitation`: one clause in its root-row sentence that a root row rewrites only the path mentions and
      links it can resolve from the citing file, so a test fixture's relative `../adr/...` string and a bare `](adr/...)` link are found by
      a search for the old folder name and fixed by hand (check: `Test-Links` on the page).
- [ ] `docs/explanation/file-meta.md`: one sentence that a kind's id names its subscriber, so kind `drs-codes` calls
      `Get-DrsCodesFileMetaFact`, and renaming either means renaming both (check: `Test-Links` on the page).
- [ ] `Move-Diagram`'s page: one sentence under its synopsis that it moves with `git mv`, so a session that may not change git moves the
      pair on disk and re-points the links a `-DryRun` lists (check: `Test-Links` on the page).
