---
plan:
  status: active
  value: high
  reviewed: 2026-10-23
  class: debt
  targets: [pwsh/.internal/assets, pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1, pwsh/Catzc.Base.Git/Get-GitAttributeValue.ps1]
---

# Debt tier tripwire: L0 and L1 tests that launch git, invisible to every run but a tier-filtered one

catzc-5d ran L0 and L1 alone on 2026-10-23 and found 165 failures (`out/catzc-5d-tier-triage.md`, reports
`out/test-automation/20261023-131510` and `-131723`). `Invoke-TestRun.ps1:156-161` arms the real-process tripwire only when `-MaxLevel` is
below 2, so a default run, `Invoke-TestFile` and every single-file run never arm it, and a real `git` launch in an L0 or L1 test is caught
only by a tier-filtered run (ADR-AUTO-TEST-PROCESSTRIPWIRE). The cause is in the tests and their seams, not in the filtered run.

## Decided (the orchestrator as delegated, 2026-10-23)

- A git call an L0 or L1 test reaches goes through a seam the test mocks, so the fast tiers stay fast; a test whose point is the real
  process moves to L2 with its tool self-skip. Mocking is the default; re-tiering is for a test that proves the launch itself.
- The tripwire must catch a violation in every run, not only a filtered one: it is armed per test container by the tier its outermost
  Describe carries, not once per run.

## Open steps

1. [ ] `pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1:46` (`git ls-files --error-unmatch`, 73 failures and most of the 45
       BeforeAll cascades: Build-RootConfig, Build-ContractReference, Build-Glossary): the tracked-file question goes through one mockable
       seam, and each failing L0/L1 test file mocks it. Check: L0 and L1 runs of those files with `-MaxLevel 1` green, same It and Should
       counts.
2. [ ] `pwsh/Catzc.Base.Git/Get-GitAttributeValue.ps1:34` (`git check-attr`; Build-EnglishDictionary, Test-MarkdownTitle.Repository): the
       same, one seam mocked in the fast tiers. Check: those files with `-MaxLevel 1` green.
3. [ ] The direct launches, one test file per step, mock or re-tier as the decision says: Get-ListenDiff's `git diff --no-index`
       (Complete-DocNote, Get-DocChange, Wait-DocNote: 23), Move-Diagram's `git init` (10), Push-Topic.Flow's `rev-parse`/`ls-remote` (6),
       Get-WorldMapHighlight's `git status` (1), and the BeforeAll setups that `git init` (Invoke-ModuleBuild 25, Get-DrsUsage 6,
       Test-RootConfigFiles 6). Check: each file with `-MaxLevel 1` green, or at L2 with its self-skip, the counts unchanged.
4. [ ] The five failures that are not launches: ConvertTo-NormalName (VSCode against Vscode, likely the user's case-only rename; confirm
       first), Get-InternalAssetDependency.Integrity (the New-Cspell asset has no non-source-only It), Build-RootConfig's two go.work cases,
       Test-Links.Untracked. Each gets its cause read and fixed or routed. Check: each file green in a default run and with `-MaxLevel 1`.
5. [ ] `pwsh/.internal/assets/Invoke-TestRun.ps1`: the tripwire is armed per container by its outermost Describe's tier, so a full run
       catches an L0/L1 launch too. Check: its test file with a fixture L0 container that launches a process fails, and an L2 one passes.
       Lands last, after steps 1 to 4 make the tree green under it.
6. [ ] Re-run L0 and L1 alone (`Test-Automation -MinLevel n -MaxLevel n`, one call per tier) and record the counts here. Check: 0 failed in
       both.
