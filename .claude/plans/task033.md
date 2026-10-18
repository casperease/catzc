---
task:
  id: "033"
  status: open
  plans: [plan-unboxing]
  value: low-medium
  blocked_on: step 1 is the user's commit
  targets:
    [
      automation/.compiled,
      automation/Catzc.Base.Contracts/types,
      automation/Catzc.Base.Objects/types,
      docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task033.md"
    folder: plans
    name: task033
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task033: unboxing closed

P1 to P3 shipped with 110 of 110 tests; the figures are in the article. Verified 2026-10-17: `automation/.compiled` holds one DLL
(`Catzc.Types.1d35234a.dll`) and its manifest, so the Clear-ModuleTypeCache step is already satisfied. Left: the user's commit, the three
leftover checks in prompt-unboxing-continue.md, two gate findings in this work's files, and P4 and P5 only on a go.

## Steps

1. The user commits the types, tests, docs and the one DLL. Check: `git status` clean for them; `.compiled` still holds one DLL.
2. [x] The three leftover checks from `prompt-unboxing-continue.md` lines 40 to 46 (the "check the leftovers" block): run each in the
       background as the prompt says, report only. Check: the report lists each with its verdict. Done 2026-10-17, read-only by session
       catzc-6c: (1) `automation/.compiled` holds exactly one pair, `Catzc.Types.c4b1ec93.dll` and its manifest (the hash moved with today's
       type edits; git shows the old `f5354111` pair deleted and the new one untracked, the user's commit); (2) `Test-ShippedTypes` in a
       fresh process: `No shipped-types issues found.` (`out/test-shipped-types/20261017-210518`), so the two Variants findings are gone;
       (3) the optional ADR-AUTO-CACHE sentence on type-level statics is put to the user in the report; declined 2026-10-18 (D18).
3. [x] Gate findings in this work's files: the phrase "full suite" in the unboxing article becomes "all tests"; the Test-Markdownlint
       findings in the same article; `Format-Links` on `TypeShape.cs` aligns its bare citations. One file per step. Check: Test-Glossary,
       Test-Markdownlint, Test-Links clean on the two files. Done 2026-10-17: the phrase replaced; `MDLINT article issues=0`,
       `LINKS issues=0` on both files, Test-Glossary reports nothing on either (`out/t033-a.ps1`); correction: `TypeShape.cs` had no bare
       citation left, `[Format-Links] Links: all 1 file(s) already aligned`.
4. [x] D11: if go, write the P4 (parse each source once per build) and P5 (build the class-lookup GlobPattern objects once) plan as open
       steps here with a measure-first step and the 15 percent bar; if stay closed, one Decided line. Check: steps or the line. Decided
       2026-10-18: stay closed; the line is in plan-unboxing.
5. [x] `Test-ShippedTypes` flags on TrackTypeEntry and VendorEntry are task012's (Q88); record the pointer. Check: the line. Done
       2026-10-17: the pointer is in plan-unboxing's open step, and the fresh run of step 2 no longer reports the two, so nothing is owed to
       task012 from here.
6. Tick the plan's steps; `prompt-unboxing-continue.md` is a delete candidate once step 2 is reported; the plan is deleted in T036. Check:
   grep `- [ ]` counts zero. 2026-10-17: the leftover-checks step is ticked; the plan keeps the user's commit step (D11 is closed), so the
   prompt stays beside it until then.

## Report

As report-fixed.
