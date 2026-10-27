---
plan:
  status: active
  value: high
  reviewed: 2026-10-27
  class: meta
  targets: [docs/drs]
---

# DRS simplification: contradictions settled, tiers clean, one rule per point

The records are strong but have grown. The in-place prose pass landed (57 records tightened, no code, heading or anchor changed); this plan
holds what that pass could not do in place: contradictions, content a tier too high, rules that state one thing, and sections that only
restate their rules. Every step keeps each decision and its rationale; a merged rule's code is retired and every citation re-cited in the
same change (`Update-AdrCitation`, PDR-ONELIVE). The check "the record check" means `Test-DrsRegistry` and `Test-Links` on the touched
records.

## Open steps

### Verify the last wave

The flow, ado and azure merges, the session-rule rename (ADR-AZ-SESSION-SEPARATECONCERNS), the BCL host rules, the folder and config
samples, the value-chain move (ADR-REPO-VALUECHAIN), ONETRACKTYPE, the arrows rule and the pewter tint rename landed with a 226-change
re-cite; five importer-path files went by staged burst, its 14 test files green.

- [ ] `Build-DrsIndex` and `Build-Glossary`, then the record check over the tree plus `Test-Spelling`, `Test-Glossary` and
      `Test-DrsEngineNeutrality`. Check: each reports 0 issues. Open: `Test-Spelling` still reports the peer files
      `.claude/hindsight/hindsightbfef75.md` (bfef, renamer, scripter) and `.claude/plans/plan-session-learnings.md:30`
      (`ADR-AUTO-TYPES-CHANGEDAFTERLOAD`, a code no record declares).

### Records still owed a full prose pass

- [ ] The same in-place tightening for `repository/` (slides-as-markdown, command-contracts, drs-code-language, uniform-formatting,
      controlled-vocabulary, markdown-links, agent-definitions and the rest), the Context bodies of the smaller `automation/` records not
      yet tightened (execution-engines, layers, idiomatic-names, materialization, use-proper-package-managers, file-limits,
      accosted-language, test-artifact-languages, tracked-files-from-the-index, test-automation), and `automation/pwsh/` (pwsh-engine,
      error-handling, powershell-formatting and every record but dynamic-module-manifests and environment-variable-mechanics). Check: the
      record check.
