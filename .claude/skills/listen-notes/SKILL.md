---
name: listen-notes
description:
  How the processor of the listen mode reads the listener's notes and keeps its own ledger; for listen-very-carefully-to-doc-changes; input
  is the session folder under out/listen.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/listen-notes/SKILL.md"
      folder: skills/listen-notes
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    edges:
      cites:
        - ADR-REPO-AI-EDITORISFACT
    config:
      model_floor: haiku
      needs: [pwsh]
---

# listen-notes

1. The editor runs `Start-DocListener`; it writes `notes/<id>.md` once each and never again. Never edit a note, a copy or an index; the
   session's out/listen folder is the one input read from out/ (ADR-REPO-AI-EDITORISFACT).
2. Wait with `Wait-DocNote` (bounded by listen.yml's note_wait_seconds) in a background call, as catzc-run says; nothing back means wait
   again. List the backlog with `Get-DocNote -Unprocessed`.
3. Read a note whole: its head (path, change, kind, tier, rules, commit) and its two diffs, this change and the arc over the session.
4. Close each note with one `Complete-DocNote -Id -FactCheck -Pattern -Plan` once its plan step is written; it is the only ledger write.
