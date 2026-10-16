# Continuation prompt: file kinds and formatting follow-ups (written 2026-10-16 15:22, carried here 2026-10-16)

The prompt names `out/plan-file-kinds-and-formatting.md`, deleted on 2026-10-16. Its done list and open items are in
`plan-file-head-immutable-edges-classes.md` beside this file, sections "Done, and why: formatter crash rule and kinds tuning" and "Open
leftovers from that follow-up". Read that plan where the prompt says to read the out/ plan. The pasted text arrived cut after "verifying
each wit" (the session's own line was "verifying each with its test or gate before the next", by the pattern of its sibling prompts; treat
that as a reading, not the source). Everything below the rule is the prompt as pasted.

---

Read .claude/CLAUDE.md and docs/adr/index.md, then .claude/plans/plan-file-head-immutable-edges-classes.md (section: formatter crash rule and kinds tuning).

The file-kind registry work, the Measure-NoOneLineHashtableIfElse rule (ADR-PWSH-FORMAT#10) and the formatter-crash fixes are done and
verified (see "Done"). Work the "Open" list in this order, one file at a time, verifying each wit
1. Re-run Test-Formatting and report what it says (expect only the compiled types .json); then check whether Format-Code should skip
   automation/.compiled and fix that if the ADR says so.
2. Decide with me whether to strengthen FileKindReachability.Tests.ps1 (open item 5) before writing anything.
3. Leave the Test-Comments findings and the untracked page alone unless I ask.
Peers edit the same tree: grep to confirm an edit still holds before building on it. No git writes.
