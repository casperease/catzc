---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/.internal/assets,
      .claude/skills/catzc-run/SKILL.md,
      .claude/skills/adr-cite/SKILL.md,
      .claude/skills/git-readonly/SKILL.md,
      .claude/skills/drawio-waves/SKILL.md,
      .claude/hooks/Assert-BashTimeout,
      pwsh/Catzc.Base.Docs/configs/glossary.yml,
      docs/adr/repository/plans.md,
      .claude/agents/gate-runner.md,
      .claude/CLAUDE.md,
    ]
---

# Agent shortcuts: a gate runner, a plan starter, a reviewer check and a glossary hint

Two lessons from the truth-stores session (2026-10-20/21), each moved from a step an agent must remember into a file that carries it. The
plan-edit hook is plan-agent-friction's, and the trim of `.claude/CLAUDE.md`'s time safeguard is that plan's step 7; this plan follows them
and never restates them. Recommended order: the gate runner, then `New-Plan`.

## Why its value is high

The session wrote a throwaway `out/*.ps1` six times to run three gates, and two sessions wrote a plan without its `## Open steps` section.
Both recur in every session that runs a gate or starts a plan.

## Decided (the user, 2026-10-21, decision round)

- **The gate runner is a repo asset**: one checked-in entry script under `pwsh/.internal/assets/`, beside `Import-ModuleFiles.ps1`, that
  dot-sources the importer, runs each named command with its arguments, prints each verdict and goes on past a failure. It is the one way a
  gate runs in a background call: `.claude/CLAUDE.md:151` (which advises a `;` command the safeguard forbids),
  `.claude/agents/gate-runner.md:34` (a per-gate `out/*.ps1`) and catzc-run's step 2 change with it (ADR-PRIN-ONELIVE).
- **`New-Plan -Topic <t> -Value <v> -Class <c>` writes the plan file only**: the head and `## Open steps`, the sections
  ADR-REPO-PLANS-ONESHAPE requires, and it refuses a topic whose file exists. The value row and the master line join once
  plan-agent-friction's step 1 makes `Test-Plans` check them, since both files are derived and edited by many sessions.

## Open steps

5. [ ] `.claude/CLAUDE.md`, the "Run PowerShell yourself" rule names `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` in place of
       `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"`; a shared file, the user's step in task-user-runs-and-commits.md. Check:
       `Test-AgentDefinitions`, `Test-Links -Path .claude/CLAUDE.md`.
6. [ ] After plan-agent-friction's step 1: `New-Plan` also writes the value row and the master line. Check: its Pester file, then
       `Test-Plans`.
7. [ ] After plan-agent-friction's hook: trim the format-plans-after-edit memory to what `New-Plan` and plan-agent-friction's hook do not
       carry. Check: a file read.
8. [ ] One line each, within their roofs: the glossary-keeper capability says to quote a YAML flow value that holds a comma (one such value
       broke every import on 2026-10-21), and the ADR-citing capability says a domain cites only the domains in its `depends_on`. Check:
       `Test-AgentDefinitions`.
9. [ ] Susan from HR: Hindsight 226bbf "If only the session had read git-readonly": `.claude/skills/git-readonly/SKILL.md` item 3 gains the
       clause "and re-read before relying on it", merged into the line, no new line. Cost today: peers trusted from stale memory, a few
       bytes per spawn. Check: `Test-AgentDefinitions`.
10. [ ] Susan from HR: Hindsight d7c207 "If only the ceiling were written" and "If only the brief file were a capability": the item of
        `.claude/skills/drawio-waves/SKILL.md` that bounds its waves (line 18) states the 20-subagent limit and that a fan-out writes its
        brief once in a file and sends each agent one line naming it, merged into that item and kept within the roof, never a new
        capability. Cost today: a 41-agent fan-out found the limit at agent 21 and wrote the brief per agent. Check:
        `Test-AgentDefinitions`.

The capability roof's counting (how `Get-RobotLineCount` counts front matter and body) is plan-session-finalize's step 1.
