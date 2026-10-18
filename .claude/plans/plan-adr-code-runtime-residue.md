---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets: [pwsh]
---

# Numbered ADR citations composed at runtime

ADR-REPO-ADRCODE spells every rule by name. The tree's literal citations are on the named form, but some production code still composes the
numbered form at runtime, which no grep for a literal finds: `Test-Plans.ps1:42` emits `[ADR-REPO-PLANS#${Rule}]`. Candidates by a first
grep: New-AdoPullRequest, Build-Glossary, Get-AdrDoraCoverageViolations, Get-AdrRuleSummaryLines, Get-MarkdownHeadingFinding,
Get-RepointedMarkdownText, Invoke-MarkdownTitleEngine (some may compose links or headings, not citations).

## Open steps

- [x] Inventory, read-only: every production site under `pwsh/` that composes `ADR-<CODE>#<n>` or `ADR-<CODE>:<n>` at runtime (string
      interpolation, format strings, concatenation), each with what it emits; written to `out/adr-runtime-residue.md` (check: each candidate
      above is classed citation or not, with its line). Verdict (catzc-a2): one citation site, `Test-Plans.ps1:42`; the seven candidates
      compose PR numbers, heading anchors, heading regexes and link fragments, each classed with its line in the inventory.
- [x] Each citation site emits the named rule (the rule's name passed in, never a number), one file at a time, its test file updated where
      it pins the message (check: that file's test passes under Invoke-TestFile; the gate's own message cites a registered rule). Verdict
      (catzc-a2): `Test-Plans.ps1`'s 18 calls pass the full code (ONETOPICONEFILE, PLANHEAD, ONESHAPE, OPENSTEP, MASTERANDTASKS), which its
      test file already pinned; "[Invoke-TestFile] Passed (in-place)" (`out/test-file/20261018-195958-fb56c7`), Format-Code 0 changes.
- [x] An analyzer or source-convention check that refuses a composed numbered citation, if one fits the existing checks (check: its test
      passes with a refusing and an accepting case). Verdict (catzc-a2): the fitting check is the link gate's string scan, not the analyzer
      or source conventions: `LinkEngine.cs`'s `StringNumberedCitation` reports `#`/`:` followed by `$` or by a `{0}` or `{name}`
      placeholder as well as a written number (the `#{1,2}` group spelling is left to the code-form checks); Format-Links.Tests gains a case
      with two refusals (an interpolated and a format-string citation) and two accepted strings (a composed named rule, a code before
      `: $Message`). "[Invoke-TestFile] Passed (in-place)" for Format-Links.Tests and Test-Links.Tests
      (`out/test-file/20261018-200108-178ca6`, `-200116-d38968`); Test-Links on the three edited files 0 issues.
- [ ] Delete this plan (check: no file in .claude/plans names it).
