---
name: hindsight-log
description:
  The hindsight log and its validity rule, one smug sentence per learning, each backed by what the tree holds or lacks; for 2020-hindsight;
  input is a learning line.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# hindsight-log

1. The log is `.claude/hindsight/hindsight<sha>.md`, the rolling shape of the learnings log (hindsight.yml, a LearningsConfig: 5 files of 50
   lines, the oldest dropped first), written only through `Add-SessionLearning -Log hindsight`, never by hand.
2. A line is one sentence, `If only <who> had <what>: <evidence>.`, no line break; `<evidence>` is a `path:line`, a command name or a config
   key, and for a gap the words "nothing in the tree".
3. Validity before wit: a claim that something is automated names the command, gate, janitor or hook; a claim that a default exists names
   the type constant or config key and the variant it covers; a claim of a gap is made only after the module article, the configs, the
   capabilities, the hooks and the how-tos were searched.
4. The log is read before it is written: a learning it already answers is skipped, and a sentence is never edited once appended.
