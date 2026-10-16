---
name: git-readonly
description:
  Git as a read-only probe of the tree; for plan-clear, adr-reviewer, session-cost-audit and every robot; input is the question about the
  tree.
user-invocable: false
allowed-tools: Bash
metadata: { catzc: { model_floor: haiku, needs: [git] } }
catzc:
  immutable:
    with_body_sha: c50619c2d871
    path: ".claude/skills/git-readonly/SKILL.md"
    folder: skills/git-readonly
    name: skill
    filetype: md
    kind: capability
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# git-readonly

1. Only `git status`, `log`, `diff`, `show`, `blame` and `ls-files`, in the foreground with `timeout: 3000`.
2. Never add, commit, push, reset, checkout, rebase, merge, stash, rm or mv; a change the user must record is named in the report under
   asks.
3. A file another session has dirty (`git status --short` shows it and the brief does not own it) is reported, never edited.
