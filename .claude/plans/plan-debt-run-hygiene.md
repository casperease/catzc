---
plan:
  status: active
  value: medium
  reviewed: 2026-10-30
  class: feature
  targets: [pwsh/Base.QualityGates, pwsh/Azure.Templates]
---

# Test run hygiene left over from the run-budget work

The full `Test-Automation` run to L2 is green inside its 240 s budget (219.6 s, run `out/test-automation/20261030-112635`); measurements
live in `out/test-run-budget/packing.md`. Two small gaps stayed open when the budget work closed.

## Open steps

1. [ ] Let `Get-MarkdownScope` (`pwsh/Base.QualityGates/private/Get-MarkdownScope.ps1`) skip a tracked Markdown file that is gone from disk,
       as `Get-DrsUsage` skips a deleted indexed path: a plan deleted but not yet committed failed the Markdown title test with "Could not
       find file". Check: `Invoke-TestFile` on `Test-MarkdownTitle.Tests.ps1` with a case for a tracked file missing on disk.
2. [ ] Build the three templates side by side in `pwsh/Azure.Templates/tests/BicepBuildCache.Prewarm.ps1`, which builds them one after
       another: 5.4-6.2 s, 5.5-6.2 s and 3.4 s of its 19-20 s. Land it only on a measured gain in the prewarm's "Prewarm done" seconds.
       Check: the prewarm's seconds before and after, and `Invoke-TestFile` on `Build-Bicep.L2.Tests.ps1`, green.

## Open questions

- Simplify proposal, not yet answered: the time-safeguard's 3 s foreground cap pushes every wait into background runs and notification
  turns; a one-line note in the `catzc-run` skill naming the background-plus-short-`tail` pattern for drones would have saved several
  stalled drones this session (each re-briefed after "could not wait on its run").
