---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [docs/adr/thesis/eac-normal-form.md, docs/adr/design/tracks.md, pwsh/Catzc.Base.Docs/configs/glossary.yml]
---

# Eac normal form: the technical migration ADR under the thesis

ADR-THES-NORMALFORM says any code, an unordered code fragment included, has an eac normal form: code that can be verified within the
enabling constraints (the sensible defaults, the catzc bundle and the local configs) and that the repository's formatters, tests and asserts
leave unchanged and do not fail. Migration brings a fragment into the form. The thesis hands the mechanics of migration to an implementation
domain, and no ADR holds them yet.

## Open questions

- Q1: Where the technical migration ADR lives. Recommendation: rules in ADR-DSGN-TRACK beside ADR-DSGN-TRACK-UNORDEREDTRACK, where an import
  lands and is sorted out with `Import-RepositoryWithHistory`. Alternative: its own ADR in `repository/`, next to ADR-REPO-FORMAT.
- Q2: The name "eac" is also the sibling repository's name (ADR-REPO-INSPIRE). Recommendation: keep "eac normal form", whose contrast in the
  glossary says it means everything as code. Alternative: spell it "everything-as-code normal form" in the ADR and the glossary.
- Q3: The glossary term `migration` is generic and will collide (a database migration, a tool migration). Recommendation: narrow it to
  `fragment migration` in ADR-THES-NORMALFORM-MIGRATIONREACHESTHEFORM and its glossary entry before other pages use it. Alternative: keep
  `migration` and add avoid entries for its other senses.
- Q4: Is the thesis drawing wanted? Recommendation: yes, one sample in `out/diagrams/dark-sample/` only: an unordered code fragment, its
  migration, the formatters, tests and asserts reaching their fixed point, and the eac normal form, all inside the enabling constraints
  (defaults, bundle, local configs). Nothing goes into `docs/` until the sample is approved.

## Open steps

1. After Q1: write the migration rules (a fragment lands unordered, is migrated one file per commit, and leaves the unordered track only
   when it is in the form), citing ADR-THES-NORMALFORM-MIGRATIONREACHESTHEFORM. Check: `Test-AdrRegistry`, `Test-Links` on the ADR.
2. After Q1: a check that proves a file is in the form, which re-runs Format-Code on it and fails on any change, so that "uncontested" is a
   gate, not prose (ADR-THES-NORMALFORM-UNCONTESTED). Check: its L0 Pester file.
3. After Q2: rename the term in `docs/adr/thesis/eac-normal-form.md` and in the glossary sources only if Q2 picks the long spelling. Check:
   `Test-Glossary`.
4. After Q3: the `migration` term narrowed (or its avoid entries added) in `docs/adr/thesis/eac-normal-form.md` and
   `pwsh/Catzc.Base.Docs/configs/glossary.yml`, then `Build-Glossary`. Check: `Test-Glossary`.
5. After Q4: the sample drawing through `drawio-diagram-waves` or `edit-diagram-yml`, one `diagram.drawio.yml` in
   `out/diagrams/dark-sample/`. Check: the user approves the sample; only then a step places it beside the ADR's explanation.
