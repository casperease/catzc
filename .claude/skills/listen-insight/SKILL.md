---
name: listen-insight
description:
  How one note of the editor becomes a pattern and a repository-wide plan in the listen mode; for listen-very-carefully-to-doc-changes;
  input is one note and the plans folder.
user-invocable: false
allowed-tools: Bash, Read, Edit, Write, Agent
metadata:
  catzc:
    config:
      model_floor: opus
---

# listen-insight

1. The note is fact (ADR-REPO-AI-EDITORISFACT): a correction, never a question; where the reference disagrees, the repository is wrong.
2. Name what the correction does (sharpens, widens, renames, removes, adds), why the editor spent time on it, and the earlier notes it
   repeats.
3. Brief the `fact-checker` with the note's new text against the reference; "does not hold" lists the plan's targets, "holds" a restated
   truth, the counter and word findings are context or glossary steps; fan `doc-pattern-scout`s over the reference by tier and slice, every
   match a target, with no cap.
4. Write or extend `.claude/plans/plan-listen-<pattern>.md` to the plan rules: steps ordered rule, docs, code, each naming its file and
   check at the pinned commit; only an edit with two readings whose matches differ becomes an open question, both sets shown.
