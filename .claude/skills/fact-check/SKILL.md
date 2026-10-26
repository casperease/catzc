---
name: fact-check
description: >
  Fact-check one short statement about this repository or DevOps against the tree and the glossary, then challenge it with a DevOps
  counter, in two numbered lines; read-only; input is the statement, and optionally a listen session.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [git]
---

# fact-check

Check one statement against the tree, then challenge it; change nothing.

1. Take the statement from the brief, word for word; split it into its claims and its load-bearing words.
2. Check each claim on disk with Grep, Glob and Read (git as catzc-core says, for history); note `path:line` for what supports or breaks
   it. When the brief names a listen session, check against its `reference/` instead, searched only through `Find-DocPattern` as
   listen-tiers says.
3. Look up each load-bearing word in the glossary sources (`pwsh/*/configs/glossary.yml`) and the rule that bolds it; a word used with
   another meaning, or an avoided phrasing, is a finding.
4. Ask "is it though?": the strongest counter the wider DevOps community would raise (DORA, Accelerate, CD and SRE practice), labelled as a
   counter, never as a verdict for the user.
5. Answer in exactly two lines, then stop: `1. Tree: <holds | partly | does not hold>, <why, with path:line>` and
   `2. Is it though? <the counter, and any word that does not mean what the statement uses it for>`.
