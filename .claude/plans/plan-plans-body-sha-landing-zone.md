---
plan:
  status: active
  value: highest
  reviewed: 2026-10-18
  waits_on: the user's commit of the gitattributes template rename
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Languages, docs/adr/repository, .claude/CLAUDE.md, .unordered]
---

# Plans that stay true, body-sha only where it earns it, .unordered as the import landing zone

Landed: the plans rules and their gate (ADR-REPO-PLANS, `Test-Plans`), stable locators (ADR-REPO-FOLDERS#12), the PowerShell naming rule
(ADR-REPO-VOCAB#9), the landing zone and the import tool (ADR-DSGN-TRACK#17, `Import-RepositoryWithHistory`, the sort-an-import how-to), and
a body hash only on generated files (ADR-REPO-FILEMETA#3). One count is left, which settles with the user's commit.

## Why its value is highest

A plan on disk is the state a dead planning agent leaves behind, so the rules that keep it short and true carry every other plan; a writer
that stamps no head leaves its output unprovable.

## Decided in the questionnaire round of 2026-10-16 (decisions-2026-10-16.md, Q01 to Q12)

- The constraining decisions are rules now: ADR-REPO-PLANS (Q04, Q06, Q07, Q08, Q11, Q12, Q49), ADR-REPO-FOLDERS#12 and ADR-REPO-VOCAB#9
  (Q05), ADR-DSGN-TRACK#17 (Q03, Q09), ADR-REPO-FILEMETA#3 (Q10).
- Q01 the history move is decided at the first real import; the tool's contract does not depend on it. Q02 Import-RepositoryWithHistory
  takes an optional -Ref, the source's default branch by default.

## Open steps

- [ ] Phase 0, the unstamped writers: every generated file's writer stamps its head through the one head function (check:
      Test-GeneratedFiles reports Unstamped 0). 2026-10-18: the minimaps are stamped by `.claude/drawio/minimaps/stamp.ps1` (447 pages), the
      compiled-types manifest takes `carrier: none` (the user's decision), and the RootConfig template is renamed
      `assets/root/.gitattributes-template` (the user's choice; a dotfile has no extension, so the world map's stack check passes);
      `Unstamped: 2`, `importer.ps1` and `importer.sh`, because git falls back to the index copy of a `.gitattributes` missing from the
      working tree and the old template is still staged. The count reaches 0 once the user commits the rename; then this step is ticked with
      the re-run's verdict and the plan is deleted.

## Refs

- docs/adr/repository/plans.md, docs/adr/repository/file-meta.md, docs/adr/design/tracks.md
