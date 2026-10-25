---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets:
    [.claude/CLAUDE.md, .claude/skills/devbox-diagnose/SKILL.md, .claude/skills/git-readonly/SKILL.md, .claude/skills/catzc-verify/SKILL.md]
---

# Claude diet: bytes every session reads

`.claude/CLAUDE.md` is 14734 bytes (about 3684 tokens, bytes / 4, an estimate, measured 2026-10-23) read at the start of every session; the
Sub-agents section is 5167 of them and the Inspiration section 1989. Each agent's purpose already sits in its `description` front matter and
in `agents.yml`, so the Sub-agents section restates a fact held twice elsewhere; the Inspiration section's aspect-to-ADR list restates the
index. The time-safeguard trim of the same file is plan-agent-friction's step 1.

## Why its value is medium

It cuts a cost paid by every session and every spawn that loads the project instructions, but breaks nothing.

## Decided (the user, 2026-10-21, decision round)

- **The learnings log stays signed `Cats`** (Q7): no `persona` key on `CapabilityEntry`.

## Decided (delegated, the orchestrator, 2026-10-22)

- catzc-05's and catzc-ba's six finalize questions, all as recommended, and landed the same day in `edit-reminders.yml`, `catzc-run`,
  `drawio-declaration` and `debt-reduce`.

## Open steps

1. [ ] Susan from HR: `.claude/CLAUDE.md`, section Sub-agents (5167 bytes of a 14734-byte file, 2026-10-23): each bullet cut to the agent
       name and one clause, the full purpose left to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2700 bytes
       (about 675 tokens) per session. The step waits until no peer has the file dirty, and it is the user's step in
       task-user-runs-and-commits.md. Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none unregistered),
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 12100.
2. [ ] Susan from HR: Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of
       Project structure names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's
       cut; no new line, no new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check:
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` still at most 12100.
3. [ ] Susan from HR: `.claude/CLAUDE.md`, section Inspiration (1989 bytes, 2026-10-23), in the same edit as step 1 (hindsight rule: merge
       beats add, delete beats merge): the six pointer bullets Module and command design, Docs and ADR structure, Contracts, Testing,
       Pipelines and Tooling (about 900 bytes, each only a link to a record `docs/drs/index.md` already lists) become one clause, "the
       domain rules in `docs/drs/index.md` decide each aspect"; the Go bullet (its scope rule) and the copying bullet (PDR-ONELIVE) stay.
       Saves about 830 bytes (about 210 tokens) per session. Check: `Test-Links -Path .claude/CLAUDE.md`, `Test-AgentDefinitions`, and
       `wc -c .claude/CLAUDE.md` at least 800 bytes below its size before the edit.

4. [ ] Once catzc-6e's remaining-arguments change lands (catzc-97's finalize (b)): `catzc-run` step 2 names the burst-step form, a step that
       runs `Invoke-CatzcCommand.ps1 -InBurst` in the burst's own process, merged into an existing line. Check: `Test-AgentDefinitions`.

5. [ ] Plans authoring conventions (`docs/drs/repository/plans.md`): one line that steps cross-reference each other by name, never by
       number, since `Format-Code` renumbers an ordered list (catzc-59, decided by the user, 2026-10-25). Check: `Test-Links` on the page
       and `Test-Plans`.
6. [ ] `implementation-orchestrator` brief: one line that it runs as the main session, since as a subagent it cannot see the peers' replies
       (catzc-59). Check: `Test-AgentDefinitions`.
7. [ ] `.claude/skills/catzc-verify/SKILL.md`: a change to a file the Bash hook compiles (`TestTiers.cs`, a new `timeouts.yml` key) runs
       `Build-AgentHook` in the same burst, merged into the burst line (a new key broke every Bash call once). Check:
       `Test-AgentDefinitions` and the capability still at its line roof.
8. [ ] `Invoke-TestFile -MaxLevel` takes 0 and 1 too, so one file can run under the real-process tripwire instead of a whole module's tier
       run. Check: `Invoke-TestFile.Tests.ps1` with a case for `-MaxLevel 0` and one for 1, `Test-ScriptAnalyzer -Path` at 0.
9. [ ] `Test-Plans` checks that a `value-of-plan.md` row has as many cells as its table's header (only markdownlint caught a 6-cell row).
       Check: `Test-Plans.Tests.ps1` with a short row and a long row, both red.
10. [ ] `.claude/skills/catzc-check/SKILL.md`: one line naming the diagram kit's suite run,
        `uv run -q --no-sync --project python python -m pytest python/catzc_diagrams/tests`, kept within the capability's line roof
        (catzc-69, decided by the user, 2026-10-25). Check: `Test-AgentDefinitions`.
11. [ ] `docs/drs/index.md`, authoring conventions: one clause that the index lists records, never rule codes, which `Test-DrsRegistry`
        reads from the record itself. Check: `Test-Links` on the page.
12. [ ] `docs/explanation/index.md`, "How to read the diagrams": one clause that an inspection note is deleted when the engine answers it,
        never marked done. Check: `Test-Links` on the page.
