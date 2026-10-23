---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-AGENTS-ROBOTBODYLIMIT
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
---

# A robot agent body has at most twenty lines and long comments move to pages (ADR-REPO-AGENTS-ROBOTBODYLIMIT + ADR-REPO-COMMENTS-COMMENTPAGEPLACE)

This article is one rule: [ADR-REPO-AGENTS-ROBOTBODYLIMIT](../../drs/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)
and [ADR-REPO-COMMENTS-COMMENTPAGEPLACE](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-commentpageplace) merged into one.
It holds nothing beyond what those two rules say.

A sub-agent is a robot: its file's body, everything after the front matter, has at most `roofs.agent_body_lines` lines (20, declared once on
`AgentsConfig` and set in `agents.yml`), where a wrapped continuation counts with the line it continues and a blank or comment line counts
as nothing. Prose that outgrows a file goes to its comment page, which lives under `docs/references/` and keeps the file's own name plus
`.md`, so a page maps back to exactly one file.
