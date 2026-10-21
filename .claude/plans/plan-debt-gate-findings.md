---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/Get-DrsUsage.ps1,
      pwsh/Catzc.Base.QualityGates/Test-Plans.ps1,
      pwsh/Catzc.Base.Slides/private/Get-SlideFinding.ps1,
    ]
---

# Debt gate findings: three gates report what sessions met by hand

Three checks leave a fact for a session to find by hand: a deleted file still in the index, a master or value step list drifting from its
plan, a slide order with a gap. Each step is one command with its test file and its comment page; the chunk owns those files only.

## Open steps

1. [ ] The deck order check of `Test-Slides` against the real decks: the shared private `Get-SlideOrderFinding` (gap and duplicate), called
       by `Build-SlideDeck` and `Test-Slides`, landed with its tests green (catzc-e3, 2026-10-22); a real deck with an order gap now fails
       the gate. Check: one live `Test-Slides` over the slide decks under `docs/` reports 0 issues, or names each deck to fix.
