---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  waits_on: the user's run of out/delete-probes-batch1.ps1, and a yes for batch two
  targets: [pwsh/Catzc.Base.Reports/configs/output-formats.yml, pwsh/Catzc.Base.Reports, docs/adr/repository/dedicated-output-directory.md]
---

# Configurable output artifacts with sensible defaults

The out/ areas, their retention and `Clear-Output` are in the tree. What remains is deleting the one-off probe scripts the harvest found, a
batch at a time on the user's yes.

## Why its value is medium

The out/ root is a contract and it is noisy. Low risk, clear win, but no other plan waits on it.

## Decided

- `out/harvest-verdicts.md` holds one verdict per script; probes are deleted a batch at a time (Q77). A probe deletion skips anything
  younger than the session asking and anything listed in `out/harvest-keep.txt`.

## Open steps

- [x] Batch one approved 2026-10-16 (B5): 222 probes older than 14:57 listed in out/harvest-batch1.txt; the sandbox refused a bulk delete,
      so the user runs out/delete-probes-batch1.ps1 (check: the listed files are gone; nothing in harvest-keep.txt is). Done 2026-10-18 by the user (`out/run-user-git-2.ps1` step 3): "deleted 234 of 235 (the rest were already gone); kept 41".
- [x] Batch two, the 13 probes of 2026-10-16 kept in harvest-batch1-kept-young.txt, now that their sessions are done (check: a yes, then the
      same).

## Refs

- docs/references/out.md, docs/adr/repository/dedicated-output-directory.md
- out/harvest-verdicts.md, out/harvest-batch1.txt, out/harvest-keep.txt
