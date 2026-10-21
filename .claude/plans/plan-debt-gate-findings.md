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

1. [ ] Susan from HR: hindsight 031350, "If only the usage command looked before it read": `Get-GitTrackedPath.ps1.md:17` says a file
       deleted from the working tree is still listed from the index, yet `Get-DrsUsage.ps1:39` reads every listed path with `ReadAllText`
       and no existence check, so a staged-but-deleted file throws. Cost: a failed run per pending deletion. Change: skip an indexed path
       missing from disk, with a test case, and its page says so. Check: `Invoke-TestFile` on `Get-DrsUsage.Tests.ps1`.
2. [ ] Susan from HR: hindsight d7c207, "If only Test-Plans compared what it counts": `Test-Plans.ps1.md:22` checks only that a master chunk
       line and a value row exist, so a step list that drifts from the plan's open steps is found by diff. Cost: one manual diff per closing
       sweep. Change: a finding when the master chunk line or the value row names a step count other than the plan's open steps, with a test
       case and the page line. Check: `Invoke-TestFile` on `Test-Plans.Tests.ps1`, and `Test-Plans` passes the live folder.
3. [ ] Susan from HR: hindsight d7c207, "If only the deck had been asked by a gate", and hindsight 031350, "If only the article had named
       the attribute": `Get-SlideFinding.ps1.md:15-17` checks that an order is a whole number but never a gap, and says nothing of a field
       rendered into an attribute. Cost: slides counted by hand; an image src fails until the code is read. Change: a gap in the slide
       orders is a finding, with a test case; the page says both that and that an attribute-rendered field is found among attribute values.
       Check: `Invoke-TestFile` on `Get-SlideFinding.Tests.ps1`.
