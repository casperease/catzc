---
name: session-finalize
description:
  Bring this main session to its finalization phase, a checkpoint the user runs any time before clearing it; the user invokes it, no robot;
  input is the session's own context.
user-invocable: true
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/session-finalize/SKILL.md"
      folder: skills/session-finalize
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: sonnet
      needs: []
---

# session-finalize

1. A checkpoint, run any time and repeatable: the session can end without warning, so what it owes lives in the tree, never only in context;
   it never ends or clears the session, the user does.
2. Plans: every plan in `.claude/plans/` this session touched or owes work to records that work as open steps (git and `Test-Automation`
   runs are the user's, never steps); a repeat run adds only what is new; a plan dirty in a peer's session gets a new plan instead; then
   `Format-Code -Language markdown` and `Test-Plans`.
3. Report three sections: **What the repository learned**, the changes made, at most 5 lines, condensed and factual; **What I learned**, at
   most 10 lines, each completing "In hindsight I wish I knew this fact: …", a fact true of the repository now, never the session's story;
   **Token tips**, 1 to 3 lines, each completing "Next time, save tokens by: …"; append both learned and tips (as `Token tip: <line>`) to
   the log with one `Add-SessionLearning '<line>', …` in the background.
4. Simplify: for each learning, propose where it shrinks what the next session reads (a `.claude` instruction cut or merged, a doc made
   plainer, a diagram); apply none unasked, and record an unanswered proposal as an open question in a plan; then end with "ready to clear"
   and the plans touched, nothing after it.
