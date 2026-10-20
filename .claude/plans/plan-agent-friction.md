---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      .claude/CLAUDE.md,
      .claude/skills/catzc-run/SKILL.md,
      .claude/hooks,
      pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1,
      docs/how-to,
      docs/explanation,
    ]
---

# Agent friction: fold what a session had to rediscover into instructions, gates, docs and one drawing

The docs-link head session (plan-docs-link-head) spent most of its effort on things the repository already knew but held where the main
session does not look, or spread over five files: the time safeguard (learned from a hook denial), the plan-edit checks (held only in
memory), a gate without `-Path`, the file-meta engine's call path (traced by hand), and the fact that switching a head on brings every kind
with it. Each item below moves one of those to the one place that serves it. Recommended order: steps 1, 2 and 4 first (cheapest, most
friction removed), then 3, then 5, then 6.

## Open questions

- **Q1: How is "Format-Code + Test-Plans after a plan edit" enforced?** Recommendation: a PostToolUse hook on Edit and Write under
  `.claude/plans/` that prints the reminder and the exact two commands into the session; it runs no pwsh, so it costs milliseconds, and it
  is a C# hook beside `Assert-BashTimeout`, published by `Build-AgentHook` (ADR-PRIN-POKAYOKE). The alternatives are a hook that runs the
  two commands (an importer run of seconds per edit, over the foreground limit) or one more line in `.claude/CLAUDE.md` (the memory rule
  already failed twice).
- **Q2: Does the main session load `catzc-run` or read its three lines from `.claude/CLAUDE.md`?** Recommendation: `.claude/CLAUDE.md` keeps
  one line that names the skill and states the one-command background form; the skill holds the rest, so the rule has one living version
  (ADR-PRIN-ONELIVE) and every turn pays for one line, not twenty.
- **Q3: Is the drawing wanted after the sample?** Recommendation: yes, one sample first in `out/diagrams/dark-sample/` (nothing rendered
  into `docs/` unasked), then placed beside the explanation page of step 5 once approved.

## Open steps

1. [ ] `.claude/CLAUDE.md`, section Time safeguard: replace the two long bullets with the one line Q2 settles, keeping the rule code
       ADR-AUTO-FAILFAST-BOUNDEVERYWAIT, the 3000 ms foreground limit, the `timeout <s>` background prefix and the pointer to `catzc-run`.
       Check: `Test-AgentDefinitions` passes and `grep -c "timeout" .claude/CLAUDE.md` shows the section shrank.
2. [ ] `.claude/skills/catzc-run/SKILL.md`: add, within its 10 lines, that a gate takes its paths only when it has a `-Path` parameter.
       Check: `Test-AgentDefinitions` passes (the capability line limit).
3. [ ] The plan-edit hook as Q1 settles: a new `.claude/hooks/<name>/` program, its registration in `.claude/settings.json` and in the
       agents/capabilities registry where `Test-AgentDefinitions` requires it. Check: `Invoke-TestFile` on the hook's test file, and an edit
       of a plan in a fresh session prints the reminder.
4. [ ] `pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1`: add `[string[]] $Path`, passed to the formatter check the way `Test-Links` and
       `Test-Comments` pass theirs, so every gate scopes the same way (ADR-PWSH-PARAM). Check:
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` passes with a new `-Path` case, and
       `Test-ParameterConsistency` passes.
5. [ ] `docs/how-to/pwsh/add-a-head-fact.md` (new): the six steps from a wanted fact to an imprinted head (kind in `file-meta.yml`, the
       processor `Get-<Kind>FileMetaFact` found by name, `select:` and the head policy order, its test, `Format-FileMeta` on one module, the
       gates), with one paragraph on the consequence that a head switched on brings every kind that selects the file. It links
       ADR-REPO-FILEMETA and ADR-REPO-CODEMETA, never restates their rules. Check: `Test-Links -Path docs/how-to/pwsh/add-a-head-fact.md`
       and `Format-Code -Language markdown` on it.
6. [ ] The drawing as Q3 settles: one diagram, "what decides a head and what fills it": the policy order (class entry, then a comment page,
       then the default) on the left, the kinds that select the file adding their lines on the right, ending in `docs` and `test`. Sample in
       `out/diagrams/dark-sample/` only. Check: the user approves the sample.
