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

## Decided (the user, 2026-10-21, decision round)

- **The migration rules sit in ADR-DSGN-TRACK** (`docs/adr/design/tracks.md`) beside ADR-DSGN-TRACK-UNORDEREDTRACK, so landing, sorting and
  leaving the track are one lifecycle; the new rules add no reader of the track.
- **The term stays "eac normal form"**, and its glossary entry gains an avoid note against the sibling repository's name (ADR-REPO-INSPIRE);
  the contrast it carries today is with `repository normal form`, not "everything as code".
- **`migration` narrows to `fragment migration`** in ADR-THES-NORMALFORM-MIGRATIONREACHESTHEFORM and its glossary entry (the database sense
  lives in `terminology.yml:893`).
- **The thesis drawing is wanted, as one sample** in `out/diagrams/dark-sample/`: an unordered code fragment, its migration, the formatters,
  tests and asserts reaching their fixed point, and the eac normal form, all inside the enabling constraints. Nothing goes into `docs/`
  until the sample is approved.

## Open steps

1. [ ] `docs/adr/design/tracks.md`: the migration rules (a fragment lands unordered, is migrated one file per commit, and leaves the
       unordered track only when it is in the form), citing ADR-THES-NORMALFORM-MIGRATIONREACHESTHEFORM. Check: `Test-AdrRegistry`,
       `Test-Links` on the ADR.
2. [ ] A check that proves a file is in the form, which re-runs Format-Code on it and fails on any change, so that "uncontested" is a gate,
       not prose (ADR-THES-NORMALFORM-UNCONTESTED). Check: its L0 Pester file.
3. [ ] `pwsh/Catzc.Base.Docs/configs/glossary.yml`: the `eac normal form` entry gains an avoid note naming the sibling repository, then
       `Build-Glossary`. Check: `Test-Glossary`.
4. [ ] `docs/adr/thesis/eac-normal-form.md` and `pwsh/Catzc.Base.Docs/configs/glossary.yml`: `migration` becomes `fragment migration` (key
       `fragment_migration`), then `Build-Glossary`. Check: `Test-Glossary`.
5. [ ] The sample drawing through `drawio-diagram-waves` or `edit-diagram-yml`, one `diagram.drawio.yml` in `out/diagrams/dark-sample/`.
       Check: the user approves the sample; only then a step places it beside the ADR's explanation.
