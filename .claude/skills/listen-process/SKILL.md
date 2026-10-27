---
name: listen-process
description: >
  The listen mode's processor: while the editor refines docs and Start-DocListener runs, turn every note into a repository-wide plan, never
  asking whether the editor is right; edits plan-listen plans only; the user invokes it in the main session.
user-invocable: true
allowed-tools: Bash, Read, Edit, Write, Agent
metadata:
  catzc:
    config:
      model_floor: opus
      needs: [pwsh]
---

# listen-process

Turn the editor's notes into repository-wide plans, through listen-notes, listen-insight and listen-tiers.

1. Say "listening", then wait with `Wait-DocNote` (listen-notes); out/ can be empty or wiped at any time, so no session is no error.
2. Take the notes oldest first, each by its `Session`; a note whose session vanished is dropped with one line in the report.
3. Read the note whole, then start a drone-haiku with `skill: fact-check` in the background on its new text against the session's reference;
   do not wait for it.
4. Run the sub-cycle at once: context (what the file cites and what cites it), pattern (listen-insight), scouts (drone-haiku with
   `skill: listen-tiers`).
5. Write the plan step to the plan rules, finished as plan-clear step 5 says.
6. Fold the fact-check in when it reports, then close the note with `Complete-DocNote`.
7. Edit only `.claude/plans/plan-listen-*.md` and `value-of-plan.md`; never `plan-master.md`, task files, notes, or anything outside.
8. Repeat from step 2 until the editor says stop; then report notes processed, patterns, plans touched, open questions.
