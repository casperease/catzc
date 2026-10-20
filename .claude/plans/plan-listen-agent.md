---
plan:
  status: blocked
  blocked_on: the user's commit of the fact-checker change (agents.yml, CLAUDE.md, catzc-worker.md, fact-checker.md)
  value: high
  reviewed: 2026-10-20
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Docs/configs/agents.yml,
      .claude/CLAUDE.md,
      .claude/agents/catzc-worker.md,
      .claude/agents/fact-checker.md,
      docs/adr/thesis/one-source-of-truth.md,
    ]
---

# The listen mode: register the processor and settle the seed

The listen mode's listener (`Start-DocListener`, `Catzc.Tooling.Listen`), its processor robot (`listen-very-carefully-to-doc-changes`), its
scout (`doc-pattern-scout`) and their three capabilities are in the tree. Left: the registration that waits on the fact-checker change, the
fact-checker's fit for the mode, and the questions the session's seed raised.

## Why its value is high

Until the two robots are registered, `Test-AgentDefinitions` fails and a session cannot be told the processor exists.

## Decided (2026-10-20, from the user)

- In listen mode the editor's edit is fact (ADR-REPO-AI-EDITORISFACT); everywhere else the truth is the repository at one commit.
- The listener is a command with no model; the processor is the robot; the notes and the ledger are their contract, one writer each.
- Doc types are the file kinds of `file-kinds.yml`; `listen.yml` groups them into tiers, so no doc-type registry of its own.
- The processor's wait is bounded by `listen.yml`'s `note_wait_seconds` (300 s, under the background roof), so it needs no `timeouts.yml`
  entry.

## Open steps

- [ ] `pwsh/Catzc.Base.Docs/configs/agents.yml`: add the entries for `listen-very-carefully-to-doc-changes` and `doc-pattern-scout`, as
      drafted in `out/listen-build/registry-entries.md` (check: `Test-AgentDefinitions`).
- [ ] `.claude/CLAUDE.md`: add the two `## Sub-agents` bullets from the same draft (check: `Test-AgentDefinitions`).
- [ ] `.claude/agents/catzc-worker.md`: name the two robots in its `Do NOT` clause (check: `Test-AgentDefinitions`).
- [ ] `.claude/agents/fact-checker.md`: read the listen session's `reference/` when the brief names one, and search it through
      `Find-DocPattern` (check: `Test-AgentDefinitions`).

## Open questions

- Does the `fact-checker` drop from sonnet to haiku, as asked for the listen mode, or keep its `model_reason`?
- From the seed below: is the mode a thesis rule or a principles rule that specialises the thesis?
- From the seed below: what is the term for what one repository is the responsibility boundary for, given that "domain" already means an ADR
  domain?
- From the seed below: the gates and agents work on the working tree; is the working tree the proposal for the next commit, with the last
  commit the truth?

## Carried

The user's seed for this session (2026-10-20), the worked example the processor's first cycle runs on:

> In any other context the AI must always use the current state of truth in a global, repository-wide context, with no preference for where
> truth comes from, looking only at committed files. This is fundamental to the single-source-of-truth ADR. Our single source of truth in
> all other modes is the system as a whole, immutable at a commit `xyz123`, as the single source of truth for our responsibility domain. A
> responsibility domain is that which a git repository is the responsibility boundary for, at org, team, product or person level: an
> org-mono-repo, a team-mono-repo, a personal repo. With git we are bound to each repository being the one responsibility domain that can be
> security-controlled; we cannot separate responsibilities by hard controls inside a repository unless we cross branch boundaries or
> client-to-server pushes. So a repository is one responsibility domain, e.g. a product repository holding its complete tooling, pipelines
> and configuration, including real prod, except secrets.
