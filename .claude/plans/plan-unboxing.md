---
plan:
  status: blocked
  class: feature
  value: low-medium
  reviewed: 2026-10-16
  blocked_on: the user's go for P4 and P5, and the commit of the changed types
  targets: [automation/Catzc.Base.Contracts/types, automation/Catzc.Base.Objects/types, automation/.compiled, docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md]
---

# Unboxing: P1 to P3 shipped; P4 and P5 wait for a go

P1 to P3 are finished and the shipped article carries the figures. The continuation prompt beside this file (prompt-unboxing-continue.md)
says what a fresh session checks first and what P4 and P5 would be. The long reference (reference-unboxing.md) sits beside it.

## Why its value is low-medium

The measured wins are in: ContractValue.Kind 37 to 11 ns, Equal(int,int) 107 to 17 ns, TypeShape as the one per-type reflection table
behind DictionaryRecord and ConsoleText (ToString 2,074 to 912 ns). What is left shortens a build only: parse each source once per build
instead of three times (P4), and build the class-lookup GlobPattern objects once (P5). The bar for either is a 15 percent gain on its row
with no new allocation, else it is reverted.

## Done, and why

- P1 to P3 as above; 110 of 110 tests pass across ContractValue, ContractSchema, ContractFragment, DictionaryRecord and ConsoleText.
- Get-CommentScope timed at 158 ms for its loop, under the 200 ms bar, so unchanged (no-go recorded).
- Two earlier evidence files the prompt names, plan-unboxing-findings.md and analysis-boxing.md, were deleted from out/ on 2026-10-16
  with the user's yes, as done work. Their findings live in the shipped article and in reference-unboxing.md beside this file. The
  benchmark scripts bench-unboxing.ps1, bench-unboxing.cs, bench-unboxing.log and run-unboxing-tests.ps1 stay in out/ as scripts.

## Needed docs

- Optional one-sentence ADR line on type-level statics in ADR-AUTO-CACHE, only if the user wants it.

## Needed tests

- automation/.compiled holds exactly one Catzc.Types.*.dll after the user commits it.
- Test-ShippedTypes re-run in a fresh process: it flagged Catzc.Base.Variants TrackTypeEntry and VendorEntry ("does not resolve after
  import"); not part of this work; report only, fix nothing unless the user says so.

## Open steps

- [ ] The user commits the changed types, tests, docs and the one DLL (check: git status clean for them).
- [ ] A fresh session runs the three leftover checks in the prompt (check: its report).
- [ ] Only on the user's go: plan P4 and P5, measure first (check: the 15 percent bar on the row).

## Refs

- prompt-unboxing-continue.md, reference-unboxing.md (beside this file)
- docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md
