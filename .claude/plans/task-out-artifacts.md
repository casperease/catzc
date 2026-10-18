---
task:
  status: open
  plans: [plan-out-artifacts]
  value: medium
  blocked_on: steps 1 and 2 are the user's confirmations
  targets: [out]
---

# Task: the out/ harvest closed

The out/ areas are registered in output-formats.yml and `Clear-Output` prunes them. The harvest left two probe batches to delete.
`out/delete-probes-batch1.ps1` and the three harvest lists are no longer in out/: either the user ran the script or out/ was cleared.

## Steps

1. Batch one: the user confirms `out/delete-probes-batch1.ps1` ran (222 probes older than 2026-10-16 14:57, listed in
   `out/harvest-batch1.txt`; `audit-file-kinds.ps1` and `count-kinds.ps1` pulled back as reruns). Check: the listed files are gone; nothing
   in `harvest-keep.txt` is.
2. Batch two: the 13 probes of 2026-10-16 in `harvest-batch1-kept-young.txt`, once their sessions are done; a yes, then the same. Check:
   gone; the user confirms.
3. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
