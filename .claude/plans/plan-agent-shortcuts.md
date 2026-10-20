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
    ]
---

# Agent shortcuts: a gate runner, a plan starter, a reviewer check and a glossary hint

Four lessons from the truth-stores session (2026-10-20/21), each moved from a step an agent must remember into a file that carries it. The
trims of `.claude/CLAUDE.md` and `catzc-run`, and the plan-edit hook, are plan-agent-friction's; this plan follows them and never restates
them. Recommended order: steps 6 and 7 first (free and cheapest), then the gate runner, then `New-Plan`.

## Why its value is high

The session wrote a throwaway `out/*.ps1` six times to run three gates, two sessions wrote a plan without its `## Open steps` section, a
"never" rule was written before the tree was searched for the thing it forbids, and a gate rejected "problem domain" only after the fact.
Each recurs in every session that runs a gate, starts a plan, writes a rule or uses a defined term.

## Open questions

- Q1: Where the gate runner lives. A background call allows no `;`, so `pwsh -Command ". ./importer.ps1; <gate>"` is denied and a script
  file is needed. Recommendation: one checked-in entry script under `pwsh/.internal/assets/`, beside `Import-ModuleFiles.ps1`, that
  dot-sources the importer and runs each named command with its arguments, prints each verdict, and goes on past a failure. Alternative: a
  script under `.claude/` as vendor settings.
- Q2: A plan template file or a `New-Plan` command. Recommendation: `New-Plan -Topic <t> -Value <v> -Class <c>`, which writes the head, the
  required sections (`## Why its value is high`, `## Open questions`, `## Open steps`) and the value-of-plan row, because a template is
  copied by hand and drifts from the head policy `Test-Plans` checks. Alternative: `.claude/plans/.template.md`.

## Open steps

1. After Q1: the entry script, with an L0 test that a passing and a failing command both report and the run continues. Check: its Pester
   file under `Invoke-TestFile`.
2. After step 1: confirm `.claude/hooks/Assert-BashTimeout` allows `timeout <s> pwsh -NoProfile -File <script> <args>`. Check: the hook's
   tests, or no denied-call line in `out/time-safeguard.log` for one real run.
3. After step 2 and after plan-agent-friction's Q2: point step 2 of `.claude/skills/catzc-run/SKILL.md` at the entry script, so no agent
   writes an `out/*.ps1` to run a gate. Check: `Test-AgentDefinitions`.
4. After Q2: `New-Plan` (or the template), and `docs/adr/repository/plans.md` naming it as the way a plan starts. Check: its Pester file,
   then `Test-Plans`.
5. After step 4: trim the format-plans-after-edit memory to what `New-Plan` and plan-agent-friction's hook do not carry. Check: a file read.
6. Add one line to `.claude/skills/adr-cite/SKILL.md`: a rule that says "never" or "only" is checked against the commands that do the thing
   (a search for its verbs and nouns) before it is reported clean. It stays within the 10-line roof. Check: `Test-AgentDefinitions`.
7. Add an `avoid` entry to the `domain` concept in `pwsh/Catzc.Base.Docs/configs/glossary.yml`: `problem domain` ->
   `the problem catzc solves`, then `Build-Glossary`. Check: `Test-Glossary`.
