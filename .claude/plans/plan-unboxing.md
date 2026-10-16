---
plan:
  status: blocked
  class: feature
  value: low-medium
  reviewed: 2026-10-16
  blocked_on: the user's go for P4 and P5, and the commit of the changed types
  targets:
    [
      automation/Catzc.Base.Contracts/types,
      automation/Catzc.Base.Objects/types,
      automation/.compiled,
      docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md,
    ]
---

# Unboxing: P1 to P3 shipped; P4 and P5 wait for a go

P1 to P3 are finished and the shipped article carries the figures. The continuation prompt beside this file (prompt-unboxing-continue.md)
says what a fresh session checks first and what P4 and P5 would be. The long reference is docs/explanation/automation/reference-unboxing.md.

## Why its value is low-medium

The measured wins are in: ContractValue.Kind 37 to 11 ns, Equal(int,int) 107 to 17 ns, TypeShape as the one per-type reflection table behind
DictionaryRecord and ConsoleText (ToString 2,074 to 912 ns). What is left shortens a build only: parse each source once per build instead of
three times (P4), and build the class-lookup GlobPattern objects once (P5). The bar for either is a 15 percent gain on its row with no new
allocation, else it is reverted.

## Done, and why

- P1 to P3 as above; 110 of 110 tests pass across ContractValue, ContractSchema, ContractFragment, DictionaryRecord and ConsoleText.
- Get-CommentScope timed at 158 ms for its loop, under the 200 ms bar, so unchanged (no-go recorded).
- Two earlier evidence files the prompt names, plan-unboxing-findings.md and analysis-boxing.md, were deleted from out/ on 2026-10-16 with
  the user's yes, as done work. Their findings live in the shipped article and in docs/explanation/automation/reference-unboxing.md. The
  benchmark scripts bench-unboxing.ps1, bench-unboxing.cs, bench-unboxing.log and run-unboxing-tests.ps1 stay in out/ as scripts.

## Findings carried from out/plan-unboxing-findings.md (deleted today; F1 to F7 recovered from a read before deletion, F8 and F9 not)

- F1 Unboxing is 2.5 ns and allocates nothing; a box is 24 B (bench A). No place in the repo is slow because of an unbox.
- F2 ContractValue.Kind(int) 37 ns, Equal(int,int) 107 ns, Equal(string,string) 63 ns; prototypes 9.6, 14, 17 ns, 0 B (bench B). Type-test
  order and helper calls were the waste; fixed in place (P1).
- F3 DictionaryRecord.Contains 73 ns; ConsoleText.ToString 2,009 ns and 1,304 B, of which reflection lookups about 680 ns and the boxing
  GetValue about 5 percent (bench C). Cache the per-type property table; the box stays (P2).
- F4 A PowerShell-to-C# crossing is about 4 us and 2.5 KB; the C# work inside is at most 3 percent of it (bench D, noise about 2 us). In
  PowerShell the lever is fewer crossings, not fewer unboxes.
- F5 Get-CommentScope makes 4 crossings per file, about 24 ms for 1,500 files by arithmetic on F4; gated at a 200 ms bar; measured 158 ms,
  no-go (P3).
- F6 Config types unbox raw YAML once per file behind Get-Config; Hashtable storage is built once per load; 678 string.Format calls are
  nearly all on error paths. No change.
- F7 The internal .psm1 modules have no unbox and bounded loops (about 250 type files, 60 modules). No change.

## Session report of 2026-10-16 15:22, and why

- Done: P1 and P2 as the figures above; P3 no-go; 110 of 110 tests across the five touched files; docs carry the shipped figures. That
  session ran only those five files, not the suite.
- Left for the user: the importer built several Catzc.Types.*.dll during the work; .compiled must hold exactly one, so run
  Clear-ModuleTypeCache and commit the survivor with the types, tests and docs; run the full suite.
- Test-ShippedTypes flags TrackTypeEntry and VendorEntry in Catzc.Base.Variants as not resolving after import; not part of this work, not
  investigated.
- Optional: a one-sentence ADR line saying ADR-AUTO-CACHE does not cover type-level statics.
- P4 and P5 have no plan yet; one is written only when the user says so.

## Needed docs

- Optional one-sentence ADR line on type-level statics in ADR-AUTO-CACHE, only if the user wants it.

## Needed tests

- automation/.compiled holds exactly one Catzc.Types.*.dll after the user commits it.
- Gate findings peer sessions reported in this work's files (2026-10-16 15:03 and 15:14), not fixed by anyone yet: the Test-Glossary finding
  is the phrase "full suite" in the unboxing article (the sanctioned form is "all tests", as the earlier dora-explains fix shows);
  Test-Markdownlint findings in the same article; Test-Links bare citations in TypeShape.cs (Format-Links aligns them).
- Test-ShippedTypes re-run in a fresh process: it flagged Catzc.Base.Variants TrackTypeEntry and VendorEntry ("does not resolve after
  import"); not part of this work; report only, fix nothing unless the user says so.

## Open steps

- [ ] The user runs Clear-ModuleTypeCache so .compiled holds one DLL, then commits types, tests, docs and that DLL (check: one
      Catzc.Types.*.dll; git status clean for them).
- [ ] A fresh session runs the three leftover checks in the prompt (check: its report).
- [ ] Only on the user's go: plan P4 and P5, measure first (check: the 15 percent bar on the row).

## Refs

- prompt-unboxing-continue.md (beside this file), docs/explanation/automation/reference-unboxing.md
- docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md
