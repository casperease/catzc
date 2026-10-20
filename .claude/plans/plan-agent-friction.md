---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/Test-Plans.ps1,
      docs/adr/repository/plans.md,
      .claude/hooks,
      pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1,
      docs/how-to,
      docs/explanation,
    ]
---

# Agent friction: fold what a session had to rediscover into gates, hooks, docs and one drawing

The docs-link head session and catzc-e8 spent effort on things the repository already knew but held where a session does not look: the
plan-edit checks (held only in memory), a new plan's three parts (plan file, value row, master line), gates that scope by folder or not at
all, the file-meta engine's call path (traced by hand). Each step below moves one of those to the one place that serves it. Two neighbouring
items have their own owners and are not restated here: the CLAUDE.md time-safeguard trim is plan-diagram-build-learnings', and the tracked
importer runner (catzc-e8's item 5) is plan-agent-shortcuts' gate runner (its Q1 and step 2). Recommended order: steps 1, 2 and 3 first
(gates, cheapest and they replace instructions), then 4, then 5, then 6.

## Open questions

- **Q1: How is "Format-Code + Test-Plans after a plan edit" enforced?** Recommendation (catzc-e8 agrees): a PostToolUse hook on Edit and
  Write under `.claude/plans/` that prints the reminder and the exact two commands into the session; it runs no pwsh, so it costs
  milliseconds, and it is a C# hook beside `Assert-BashTimeout`, published by `Build-AgentHook` (ADR-PRIN-POKAYOKE). The alternatives are a
  hook that runs the two commands (an importer run of seconds per edit, over the foreground limit) or one more line in `.claude/CLAUDE.md`
  (the memory rule already failed twice).
- **Q2: Is the drawing wanted after the sample?** Recommendation: yes, one sample first in `out/diagrams/dark-sample/` (nothing rendered
  into `docs/` unasked), then placed beside the how-to of step 5 once approved.

## Open steps

1. [ ] `pwsh/Catzc.Base.QualityGates/Test-Plans.ps1` and `docs/adr/repository/plans.md`: a plan with no chunk line in `plan-master.md` or no
       row in `value-of-plan.md` is a finding, and ADR-REPO-PLANS gains the rule that a plan is its file, its value row and its master line,
       so no instruction has to say it (catzc-e8; it complements plan-agent-shortcuts' `New-Plan`, which writes the three, by checking
       them). Check: `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` passes with a case for each missing part.
2. [ ] `pwsh/Catzc.Base.QualityGates/Test-Plans.ps1`: `-Path` takes files as well as the folder (`[string[]]`), so a session checks its own
       plan and is not failed by a peer's (catzc-e8, ADR-PWSH-PARAM); the step-1 cross-file checks still read the whole folder. Check: the
       same test file, with a file-path case, and `Test-ParameterConsistency` passes.
3. [ ] `pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1`: add `[string[]] $Path`, passed to the formatter check the way `Test-Links` and
       `Test-Comments` pass theirs, so every gate scopes the same way (ADR-PWSH-PARAM). Check:
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` passes with a new `-Path` case, and
       `Test-ParameterConsistency` passes.
4. [ ] The plan-edit hook as Q1 settles: a new `.claude/hooks/<name>/` program and its registration in `.claude/settings.json`. Check:
       `Invoke-TestFile` on the hook's test file, and an edit of a plan in a fresh session prints the reminder.
5. [ ] After plan-minimal-heads lands: `docs/how-to/pwsh/add-a-head-fact.md` (new), the steps from a wanted fact to an imprinted head in the
       minimal model that plan sets (the warning head of a generated file, the navigation head of authored code under `file_heads.code`, the
       kind in `file-meta.yml` and its processor found by name, its test, `Format-FileMeta` on one module, the gates). It links
       ADR-REPO-FILEMETA and ADR-REPO-CODEMETA, never restates their rules. Check: `Test-Links -Path docs/how-to/pwsh/add-a-head-fact.md`
       and `Format-Code -Language markdown` on it.
6. [ ] The drawing as Q2 settles, after step 5: one diagram, "what decides a head and what fills it", the minimal model's three outcomes (a
       generated file's warning head, authored code's navigation head by its variant, no head) and the keys each holds. Sample in
       `out/diagrams/dark-sample/` only. Check: the user approves the sample.
