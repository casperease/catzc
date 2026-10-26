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

## Open questions

- Should the `Show-EditReminder` hook text add one line that `Format-Code -Path` on a plan also re-wraps `plan-master.md`? Recommended: yes,
  one clause in the hook text instead of a lesson every session relearns. Check if decided: `Test-Plans`.
- Should `catzc-run` gain one line, "a burst step is an Invoke-TestFile call or a named gate, staged with -Stage, its verdict read from the
  results XML", and should `.claude/CLAUDE.md`'s Project structure say module folders carry no catzc prefix (the track declares the
  namespace)? Recommended: yes to both, as they replace three of 2026-10-26's learnings; the CLAUDE.md line is the user's edit. Check if
  decided: `Test-AgentDefinitions` and `Test-Plans`.
- Should `catzc-check` gain one line, "a dot folder (`pwsh/.internal`) is passed to Invoke-TestFile or Test-Parsing as its file list, never
  as a folder", so no session relearns that both reject a dot-folder path? Recommended: yes, one clause in a capability already read for
  every check. Check if decided: `Test-AgentDefinitions` and `Test-Plans`.
- Should the folder-move path rewrite become a how-to page (`docs/how-to/pwsh/rewrite-paths-after-a-move.md`): the `Update-DrsCitation` code
  map built from a moves list, folder rows naming a child path (a row maps its path's parent), never a one-segment folder row, and the
  default exclusions (`.claude/CLAUDE.md`, learnings, hindsight; overlay paths stay)? Recommended: yes, it replaces rediscovery from
  `out/ns5/after-move.md` and `docs-rewrite.md` at the next move. Check if decided: `Test-Links` on the page and `Test-Plans`.
