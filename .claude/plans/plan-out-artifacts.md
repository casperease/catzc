---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  waits_on: the user's run of out/delete-probes-batch1.ps1, and a yes for batch two
  targets:
    [
      pwsh/Catzc.Base.Reports/configs/output-formats.yml,
      pwsh/Catzc.Base.Reports,
      docs/adr/repository/dedicated-output-directory.md,
    ]
---

# Configurable output artifacts with sensible defaults

Landed: the six out/ areas with their numbers are registered in output-formats.yml, sessions live under `out/sessions/<session>/`, the
time-safeguard log never ages out, and only `Clear-Output` prunes (`OutputRetention`, `Clear-Output.Tests.ps1`). What remains is deleting
the one-off probe scripts the harvest found, a batch at a time on the user's yes.

## Why its value is medium

The out/ root is a contract and it is noisy. Low risk, clear win, but no other plan waits on it.

## The harvest of out/ (2026-10-16)

`out/harvest-verdicts.md` holds one verdict per script: 235 probes (one-off, deleted a batch at a time, Q77), 20 rerun scripts kept for
their plans, and 5 tool candidates, now steps of their owning tasks (task-file-head-leftovers step 9, task-adr-link-cleanup step 9). A probe
deletion skips anything younger than the session asking and anything listed in `out/harvest-keep.txt`.

## Open steps

- [ ] Batch one approved 2026-10-16 (B5): 222 probes older than 14:57 listed in out/harvest-batch1.txt; the sandbox refused a bulk delete,
      so the user runs out/delete-probes-batch1.ps1 (check: the listed files are gone; nothing in harvest-keep.txt is).
- [ ] Batch two, the 13 probes of 2026-10-16 kept in harvest-batch1-kept-young.txt, now that their sessions are done (check: a yes, then the
      same).

## Refs

- docs/references/out.md, docs/adr/repository/dedicated-output-directory.md
- out/harvest-verdicts.md, out/harvest-batch1.txt, out/harvest-keep.txt
