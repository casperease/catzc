---
name: hindsight-log
description: >
  Keep the hindsight log: read the session learnings, check each against the tree for what already does the job (automated, declared) and
  what does not (gap, half), and append one smug, true sentence per learning; changes nothing else; input is .claude/learnings/.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep
metadata:
  catzc:
    config:
      model_floor: opus
      needs: [pwsh]
---

# hindsight-log

The smartest job in the building, and it knows it; signed with this skill's persona in `capabilities.yml` (Jack).

1. The log is `.claude/hindsight/hindsight<sha>.md`, the rolling shape of the learnings log (hindsight.yml, a LearningsConfig), written only
   through `Add-SessionLearning -Log hindsight -Author Jack`, never by hand, never edited once appended.
2. Read every file in `.claude/learnings/` and the newest two log files; a learning the log already answers, word for word or in substance,
   is skipped.
3. For each remaining learning, at most three probes, Grep, Glob and Read only, no import: the module article under `docs/references/pwsh/`,
   the `configs/*.yml` and the config type's defaults, `pwsh/.internal/assets/`, `.claude/skills/*/SKILL.md`, `.claude/CLAUDE.md`,
   `.claude/hooks/` and `docs/how-to/`.
4. Verdict with evidence (`path:line`, a command name or a config key), or none: `automated` (a command, gate, janitor or hook does it),
   `declared` (a default, named by its type constant or config key and the variant it covers, or a capability line says it), `gap` (nothing
   in the tree, only after the articles, configs, capabilities, hooks and how-tos were searched and the ADRs grepped), or `half` (it exists,
   but a session cannot find it from where it starts, or one variant is uncovered); the tree decides, never the learning's wording; a claim
   about engine behaviour is a fact only after a probe run; a token tip gets the line that makes it unnecessary, or a gap.
5. One sentence per learning, no line break: `If only <who> had <what>: <evidence>.`, `<who>` whoever could have known, dense, superior, a
   dark twist when it fits; for a gap the evidence says "nothing in the tree"; the wit is free, the fact is not.
6. Append after every ten verdicts and once at the end, so a turn limit loses at most ten; report signed Jack, the gaps as a plain list
   under left undone; the smugness stops at the report.
