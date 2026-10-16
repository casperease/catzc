# Continuation prompt: unboxing (P1 to P3 done; P4 and P5 next)

Paste this into a fresh session.

---

You are continuing the "unboxing" work in `C:\projects\catzc`. Read `docs/adr/index.md` first (cite ADR rules by code; say "domain rules" or
"ADR rules", never "house rules"). Then read `.claude/plans/plan-unboxing.md (section: Findings carried)` (findings F1 to F9, priorities, the done and not-done list) and
the Status table at the top of `.claude/plans/plan-unboxing.md`. The article is `docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md`;
the evidence is `analysis-boxing.md (deleted 2026-10-16; its findings are in plan-unboxing.md)` (§4 and §6), `.claude/plans/reference-unboxing.md`, `out/bench-unboxing.ps1` and `.cs`. Do not redo the analysis.

**State.** P1, P2 and P3 are finished and the docs carry the shipped figures:

- `ContractValue.Kind` and `Equal` test exact scalar types first (`Kind(int)` 37 to 11 ns, `Equal(int, int)` 107 to 17 ns).
- `TypeShape.cs` is the one per-type reflection table behind `DictionaryRecord` and `ConsoleText` (`ToString()` 2,074 to 912 ns).
- `Get-CommentScope` was timed: the loop is 158 ms, under the 200 ms bar, so it is unchanged.
- 110 of 110 tests pass across `ContractValue`, `ContractSchema`, `ContractFragment`, `DictionaryRecord` and `ConsoleText`
  (`out/run-unboxing-tests.ps1`).

**First, check the leftovers (cheap, no edits unless a check fails):**

1. `automation/.compiled` should hold exactly one `Catzc.Types.*.dll`. The person commits it. Do not run git state changes.
2. `Test-ShippedTypes` flagged `Catzc.Base.Variants` `TrackTypeEntry` and `VendorEntry` ("does not resolve after import"). They are not part
   of this work. Re-run it in a fresh process; report the result, and fix nothing unless the user says so.
3. Ask the user whether the optional one-sentence ADR line on type-level statics (`ADR-AUTO-CACHE`) is wanted.

**Then, only if the user says go, plan P4 and P5** (write `out/plan-<topic>.md`; do not edit code first). These are what shorten a build:

- **P4:** parse each source file once per build and share the tree across the three stages (the build parses each file 3 times).
- **P5:** build the class-lookup `GlobPattern` objects once.

Measure first, as the earlier steps did: the bar is a 15 % improvement on the row with no new allocation, and a step that misses it is
reverted.

**Constraints.** Every foreground Bash call passes `timeout: 3000` and is one plain command; anything longer runs with
`run_in_background: true` and one command prefixed `timeout <s>` (max 360), absolute paths, no `cd`, `;`, `&&` or pipes. Scripts live in
`out/`. No mutating git commands. Edit one file at a time and verify it before the next. A `types/*.cs` edit needs a fresh pwsh process. The
user runs the commits and the full suite; run per-file checks only and never claim a test passed unless you saw it pass. Render no diagram
unasked. Private functions are timed inside their module: `& (Get-Module <Module>) { ... }`.
