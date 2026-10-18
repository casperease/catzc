---
task:
  status: open
  plans: [plan-out-artifacts]
  value: medium
  blocked_on: steps 1 and 2 run in the user's out/run-user-git-2.ps1 (step 3); the permission layer refuses the deletion to sessions
  targets: [out]
---

# Task: the out/ harvest closed

The out/ areas are registered in output-formats.yml and `Clear-Output` prunes them. The harvest left two probe batches to delete.
`out/delete-probes-batch1.ps1`, `harvest-batch1.txt`, `harvest-batch1-kept-young.txt` and `harvest-keep.txt` are in out/; the user's next
run of `out/run-user-git-2.ps1` deletes the probes.

## Steps

1. Batch one: `out/delete-probes-batch1.ps1` deletes the 222 probes older than 2026-10-16 14:57 listed in `out/harvest-batch1.txt` (221
   present; `audit-file-kinds.ps1` and `count-kinds.ps1` pulled back as reruns). Check: the listed files are gone; nothing in
   `harvest-keep.txt` is.
2. Batch two: the 13 probes of 2026-10-16 in `harvest-batch1-kept-young.txt`, deleted the same way (a yes, decided 2026-10-18). Check: gone;
   nothing in `harvest-keep.txt` is.
3. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
