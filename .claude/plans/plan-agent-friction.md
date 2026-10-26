---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [.claude/CLAUDE.md]
---

# Agent friction: fold what a session had to rediscover into gates, hooks, docs and one drawing

The docs-link head session and catzc-e8 spent effort on things the repository already knew but held where a session does not look: gates
that scope by folder or not at all, the file-meta engine's call path (traced by hand), the time-safeguard section's own contradictions. Each
step below moves one of those to the one place that serves it; steps 1 and 2 land together.

## Decided (the user, 2026-10-21, decision round)

- **This plan owns the `.claude/CLAUDE.md` time-safeguard trim**: the section keeps the rule and its code
  (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT), the hook, its log `out/time-safeguard.log`, `timeouts.yml`, the denial rule and the fastest-runner
  rule, and points at `catzc-run` for the call shapes.

- **Delegated to the orchestrator, recommendations taken (2026-10-21):** step 1's trim adds one clause that the Bash hook also denies the
  git topic commands (FDR-GIT-USERRUNSGIT), named from `git.yml`, and that a script naming them is written with the Write tool.

## Open steps

1. [ ] The gate path forms a worker rediscovers go in the gates' own pages, not in `catzc-run`, which stays at its 10-line roof (the user,
       2026-10-25): the `Test-ScriptAnalyzer` page says `-Path` takes a folder and a glob `pwsh/m/**/*.ps1` analyzes one file; the
       `Test-Spelling` page says `-Path` takes globs and spells every extension, wider than its default scope. The
       `Invoke-TestFile     -MaxLevel` fact is dropped, since plan-claude-diet makes it accept 0 and 1. Check: `Test-Links` on the pages and
       `Test-AgentDefinitions`.

## Decided (the user, 2026-10-22)

- The learnings and hindsight logs are out of the glossary scan, as append-only `Add-SessionLearning` output; no hand edit, no write-time
  check, no new family forms (landed in `GlossaryOptions.DefaultExclude`, next to `.claude/plans/**`).

## Decided (delegated, the orchestrator, 2026-10-22)

- One `Format-Code` form, `-Path` on the files touched: `catzc-run` is the capability every robot that runs pwsh loads (landed in the
  plan-edit reminder, `plan-intake` and the listen robot).

- catzc-11's question taken as recommended: the HOLD and GO of an import-path burst go to every live peer, the orchestrator included (landed
  in `catzc-verify`).
