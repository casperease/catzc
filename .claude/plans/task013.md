---
task:
  id: "013"
  status: open
  plans: [plan-minimal-robots, plan-minimal-robots-agents, plan-minimal-robots-capabilities]
  value: high
  blocked_on: nothing
  targets: [.claude/agents, .claude/skills, automation/Catzc.Base.Docs/configs/agents.yml, docs/adr/repository/agent-definitions.md]
catzc:
  immutable:
    with_body_sha: bd588c235192
    repo_status: clean
    path: ".claude/plans/task013.md"
    folder: plans
    name: task013
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task013: minimal robots Phase 5, measure and reconcile

Phases 0 to 4 landed: 15 robots of at most 20 body lines, 18 capabilities of at most 10 lines, roofs in agents.yml (`roofs:` line 22,
defaults on AgentsConfig), Test-AgentDefinitions extended, ADR-REPO-AGENTS rules 6 to 10. Phase 5 measures what a spawn costs and closes the
program. Verified 2026-10-17: `drawio-diagram-waves.md` line 39 already names `drawio-png` robots as the makers (Q139), so that step is a
tick.

## Steps

1. Measure: in a session that spawned each robot once (the user's, or one the executor runs with one trivial brief per robot), run
   `session-cost-audit` with the `/cost` block; the report in `out/` gives context bytes per spawn and the model per robot. Check: the
   report names both for all 15 robots.
2. `plan-minimal-robots.md`: a table robot, model, context bytes per spawn, from the report; one line on which robots exceed 4,000 tokens
   per spawn and why (a capability too long, a model too large). Check: 15 rows.
3. Reconcile the seven shape rules in the plan's Decided section (20-line roof, cheapest usable model, 10-line capability roof, declared
   once, no orphan and no ghost, capability registry, one body shape) with `docs/adr/repository/agent-definitions.md` rules 6 to 10: read
   the five rules; each of the seven either cites a rule number or the plan says which two merged. If one is missing (likely "one body
   shape" or "no ghost"), add rule 11 in the ADR in present tense. Check: Test-AdrRegistry clean; every plan rule carries a rule code.
4. `agents.yml`: every robot's `supported_by` cites an ADR-REPO-AGENTS rule where the plan says so; the drawio-diagram-waves entry names
   drawio-png under its capabilities or `uses:` if the schema has one. Check: Test-AgentDefinitions clean (background).
5. `plan-minimal-robots-agents.md` and `plan-minimal-robots-capabilities.md`: the open questions sections become Decided or tick lines (the
   maker question is decided; the "plan-clear text awaited" and "capability 2 text awaited" states are checked against the files on disk,
   both exist since 2026-10-16). Check: grep `- [ ]` and "awaited" in both files counts zero.
6. Delete the three plans when no open step remains; three lines under "Deleted" in `value-of-plan.md` with the reason (program landed,
   measured in out/ report named). `git rm` is the user's; list the three files for them. Check: Test-Links clean on `.claude/plans`.

## Report

As report-fixed.
