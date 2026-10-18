---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets: [pwsh]
---

# Numbered ADR citations composed at runtime

ADR-REPO-ADRCODE spells every rule by name. The tree's literal citations are on the named form, but some production code still composes
the numbered form at runtime, which no grep for a literal finds: `Test-Plans.ps1:42` emits `[ADR-REPO-PLANS#${Rule}]`. Candidates by a
first grep: New-AdoPullRequest, Build-Glossary, Get-AdrDoraCoverageViolations, Get-AdrRuleSummaryLines, Get-MarkdownHeadingFinding,
Get-RepointedMarkdownText, Invoke-MarkdownTitleEngine (some may compose links or headings, not citations).

## Open steps

- [ ] Inventory, read-only: every production site under `pwsh/` that composes `ADR-<CODE>#<n>` or `ADR-<CODE>:<n>` at runtime (string
      interpolation, format strings, concatenation), each with what it emits; written to `out/adr-runtime-residue.md` (check: each
      candidate above is classed citation or not, with its line).
- [ ] Each citation site emits the named rule (the rule's name passed in, never a number), one file at a time, its test file updated where
      it pins the message (check: that file's test passes under Invoke-TestFile; the gate's own message cites a registered rule).
- [ ] An analyzer or source-convention check that refuses a composed numbered citation, if one fits the existing checks (check: its test
      passes with a refusing and an accepting case).
- [ ] Delete this plan (check: no file in .claude/plans names it).
