---
plan:
  status: blocked
  blocked_on: its three questions for the user, answered in a plan-decide round
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets:
    [
      pwsh/Catzc.Base.QualityGates/tests/Language.Bridge.ps1,
      pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1,
      pwsh/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1,
      pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1,
    ]
---

# Test signal proposals

Three proposals from a failed full run, each an open question for the user: one makes a setup failure readable from the run's report, one
replaces four hand-kept copies of the spelled file types with one config entry, and one settles an L0 test that checks real ADR codes.

## Why its value is medium

A single ruff finding failed 321 Python cases with "a setup in some parent block failed", and the cause was visible only by re-running the
bridge by hand. The spelled-types list exists four times and drifts as soon as one copy changes. Neither blocks work; both cost each session
that meets them a diagnosis.

## Open steps

- [ ] Question for the user: should `pwsh/Catzc.Base.QualityGates/tests/Language.Bridge.ps1` catch the outcome run's error in its
      `BeforeAll` and fail each case with that message, so the run's results XML names the ruff or pytest error? (check: the user's answer
      is recorded here; when yes, an L1 case with a failing lint shows the lint line in the failing case's message)
- [ ] Question for the user: should the spelled file types become one entry in the spelling config, read by `Test-Spelling.ps1`,
      `Export-SpellingTriage.ps1`, `private/Get-TerminologyCorpus.ps1` and `tests/Test-Spelling.Tests.ps1`, instead of four lists kept in
      step by hand (ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG)? (check: the user's answer is recorded here; when yes, `Grep "'.csproj'"`
      finds the extension in the config only, and the spelling and terminology tests pass)
- [ ] Question for the user: `pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1:7` checks the shipped ladder's real rule codes in an L0
      test, which the neutral-code check flags; re-tier that case to L1 integrity, or exempt the file in `source-conventions.yml` with its
      reason? (check: the user's answer is recorded here; after it lands, `Test-SourceConventions` reports nothing for the file)
