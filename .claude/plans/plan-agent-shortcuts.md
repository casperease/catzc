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

1. [ ] The entry script, with an L0 test that a passing and a failing command both report and the run continues. Check: its Pester file
       under `Invoke-TestFile`.
2. [ ] After step 1: confirm `.claude/hooks/Assert-BashTimeout` allows `timeout <s> pwsh -NoProfile -File <script> <args>`. Check: the
       hook's tests, or no denied-call line in `out/time-safeguard.log` for one real run.
3. [ ] After step 2: point step 2 of `.claude/skills/catzc-run/SKILL.md` at the entry script, so no agent writes an `out/*.ps1` to run a
       gate. Check: `Test-AgentDefinitions`.
4. [ ] After step 2: `.claude/agents/gate-runner.md` runs its gate through the entry script, not an `out/gate-runner-<name>.ps1`. Check:
       `Test-AgentDefinitions`.
5. [ ] After step 2, when no peer has the file dirty: `.claude/CLAUDE.md`, the "Run PowerShell yourself" rule names the entry script in
       place of `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"`. Check: `Test-AgentDefinitions`, `Test-Links -Path .claude/CLAUDE.md`.
6. [ ] `New-Plan` as decided, and `docs/adr/repository/plans.md` naming it as the way a plan starts. Check: its Pester file, then
       `Test-Plans`.
7. [ ] After plan-agent-friction's step 1: `New-Plan` also writes the value row and the master line. Check: its Pester file, then
       `Test-Plans`.
8. [ ] After step 6: trim the format-plans-after-edit memory to what `New-Plan` and plan-agent-friction's hook do not carry. Check: a file
       read.
9. [ ] Replace the retired numbered citation form (`ADR-X#n`, `### Rule ADR-X:n`) with the full rule code
       (ADR-REPO-ADRCODE-NAMEDNOTNUMBERED) in `.claude/skills/catzc-module/SKILL.md`, then in `.claude/agents/adr-reviewer.md`, one file at
       a time, within their roofs. Check: `Test-AgentDefinitions` after each.

The capability roof's counting (how `Get-RobotLineCount` counts front matter and body) is plan-session-finalize's step 1.
