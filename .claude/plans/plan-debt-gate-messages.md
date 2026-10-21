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

- [ ] The adr-codes select in `file-meta.yml` adds `analyzer-rule` (powershell), `pipeline`, `pipeline-template` and `template`, then one
      `Format-FileMeta` burst over those classes that also sweeps the tree-wide `[Drift]` findings; only after catzc-8b's record-kind
      rewrite (plan-xdr-codes) has landed, since it changes the same cites. Until then Test-FileMeta is red on purpose: the new
      `Get-SkippedClassCitationFinding` reports 29 pages citing rules for those classes (check: `Test-FileMeta` over the tree at 0).
