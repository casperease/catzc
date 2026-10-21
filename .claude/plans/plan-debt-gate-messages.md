---
plan:
  status: active
  value: low
  reviewed: 2026-10-21
  class: meta
  targets:
    [
      pwsh/Catzc.Base.Slides/private/Get-SlideFinding.ps1,
      pwsh/Catzc.Base.QualityGates/configs/file-meta.yml,
      pwsh/Catzc.Base.QualityGates/configs/terminology.yml,
    ]
---

# Gate messages that name their own cause

Three gates a worker session (catzc-05, 2026-10-21) had to diagnose by reading their source: each message could name the cause it already
knows.

## Why its value is low

Each costs one probe or one source read per session that meets it; nothing is blocked.

## Decided (delegated to the orchestrator, 2026-10-21; each recommendation taken)

- Test-Slides names an over-long quoted rule: "the quoted rule is N words; pattern 'rule' holds at most M".
- Test-FileMeta reports a comment page citing rule codes for a file whose class the `adr-codes` select skips.
- The `reserved` category's scope globs match case-insensitively.

## Open steps

- [ ] Test-FileMeta: a page citing rules for a skipped class is a finding (check: `Invoke-TestFile` on its test with a gadget page).
- [ ] Test-Terminology: reserved scope globs ignore case (check: `Invoke-TestFile` on its test with a mixed-case path).
