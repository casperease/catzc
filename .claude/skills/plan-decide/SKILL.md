---
name: plan-decide
description: >
  Run a decision round over the plans' open questions: a questionnaire, four questions at a time with the recommendation first, every answer
  recorded with its outcome, then folded into the owning plans; the user invokes it; input is .claude/plans and the user's answers.
user-invocable: true
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
paths: .claude/plans/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# plan-decide

The user decides, the agent records; nothing unanswered is decided by the agent.

1. Find the open questions with one grep over the plans matching all three shapes (`## Open questions`, `[ ] Open question`,
   `Proposed ... Answer: yes or no`); Read each plan's head and open sections.
2. Write `out/question-round/questionnaire-<date>.md`: one item per question, one to five lines of context, the options, no links; items are
   numbered once and never renumbered; and `out/question-round/decisions-<date>.md` with the head Q, Decision, Rec taken, Outcome, Note.
3. Ask with AskUserQuestion, four items per call; the first option is the recommendation and says so, and every option's description carries
   its why and its outcome in the tree; a "clarify" answer gets one reformulated question with the added context.
4. After each call, one row per answer: the decision, whether the recommendation was taken, the projected outcome in two to ten words, and a
   reframing quoted where it carries a new rule; a reframing answer is re-asked once in the user's terms, and an answer that puts a kind of
   item out of scope removes every item of that kind from the round.
5. When the round ends, fold each decision into its owning plan (Decided section, open steps, needed docs), one file at a time, finished as
   plan-clear step 5 says; the decisions file stays as the record until its decisions are in decision records.
6. Report the items asked and answered, the recommendations taken and not, the plans updated, and the questions left open.
