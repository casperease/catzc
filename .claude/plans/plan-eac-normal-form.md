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

## Open steps

1. After Q1: write the migration rules (a fragment lands unordered, is migrated one file per commit, and leaves the unordered track only
   when it is in the form), citing ADR-THES-NORMALFORM-MIGRATIONREACHESTHEFORM. Check: `Test-AdrRegistry`, `Test-Links` on the ADR.
2. After Q1: a check that proves a file is in the form, which re-runs Format-Code on it and fails on any change, so that "uncontested" is a
   gate, not prose (ADR-THES-NORMALFORM-UNCONTESTED). Check: its L0 Pester file.
3. After Q2: rename the term in `docs/adr/thesis/eac-normal-form.md` and in the glossary sources only if Q2 picks the long spelling. Check:
   `Test-Glossary`.
