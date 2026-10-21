---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1, docs/how-to, docs/explanation, .claude/CLAUDE.md]
---

# Agent friction: fold what a session had to rediscover into gates, hooks, docs and one drawing

The docs-link head session and catzc-e8 spent effort on things the repository already knew but held where a session does not look: gates
that scope by folder or not at all, the file-meta engine's call path (traced by hand), the time-safeguard section's own contradictions. Each
step below moves one of those to the one place that serves it. Recommended order: step 1, then 2, then 3 and 4 together.

## Decided (the user, 2026-10-21, decision round)

- **The head drawing is wanted, as one sample** in `out/diagrams/dark-sample/`, then placed beside the how-to of step 1 once approved.
- **This plan owns the `.claude/CLAUDE.md` time-safeguard trim**: the section keeps the rule and its code
  (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT), the hook, its log `out/time-safeguard.log`, `timeouts.yml`, the denial rule and the fastest-runner
  rule, and points at `catzc-run` for the call shapes.

## Open questions (session-finalize, 2026-10-21)

- Should `edit-reminders.yml` gain an entry for `pwsh/**/*.ps1` that reminds of the instant parse check
  (`[System.Management.Automation.Language.Parser]::ParseFile`), so the importer-outage memory shrinks to a config entry? Recommended: yes.
- Should step 3's trim add one clause that the Bash hook also denies the git topic commands (ADR-FLOW-GIT-USERRUNSGIT), named from
  `git.yml`, and that a script naming them is written with the Write tool? Recommended: yes, in the same cut.

## Open steps

1. [ ] After plan-minimal-heads lands: `docs/how-to/pwsh/add-a-head-fact.md` (new), the steps from a wanted fact to an imprinted head in the
       minimal model that plan sets (the warning head of a generated file, the navigation head of authored code under `file_heads.code`, the
       kind in `file-meta.yml` and its processor found by name, its test, `Format-FileMeta` on one module, the gates). It links
       ADR-REPO-FILEMETA and ADR-REPO-CODEMETA, never restates their rules. Check: `Test-Links -Path docs/how-to/pwsh/add-a-head-fact.md`
       and `Format-Code -Language markdown` on it.
2. [ ] After step 1, the drawing: one diagram, "what decides a head and what fills it", the minimal model's three outcomes (a generated
       file's warning head, authored code's navigation head by its variant, no head) and the keys each holds. Sample in
       `out/diagrams/dark-sample/` only. Check: the user approves the sample.
3. [ ] After plan-agent-shortcuts' CLAUDE.md line (its step 1): `.claude/CLAUDE.md`, section Time safeguard, trimmed as decided, when no
       peer has the file dirty. Check: `Test-AgentDefinitions` and `Test-Links -Path .claude/CLAUDE.md`.
4. [ ] Susan from HR: In step 3's trim, `.claude/CLAUDE.md` (hindsight 226bbf, "which grep"): the probe line names the Grep tool for a
       recursive search and bash `grep` only for one file, since a recursive bash grep cannot finish inside the 3 s roof; the multi-step
       "script under `out/`" clause is cut for `Invoke-CatzcCommand.ps1` (the tree contradicts itself today); the same section says in one
       clause that Bash calls use absolute paths (hindsight 226bbf, "the second half"; no line says it, a drifting folder is learned by
       failure), paid for by the cut. Check: `Test-AgentDefinitions` and `Test-Links -Path .claude/CLAUDE.md`.
