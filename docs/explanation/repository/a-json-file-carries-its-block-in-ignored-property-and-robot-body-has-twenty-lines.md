---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-JSONCARRIER
      - ADR-REPO-AGENTS-ROBOTBODYLIMIT
---

# A json file carries its block in ignored property and robot body has twenty lines

This article is one rule: [ADR-REPO-FILEMETA-JSONCARRIER](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-jsoncarrier) and
[ADR-REPO-AGENTS-ROBOTBODYLIMIT](../../drs/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit) merged into one. It holds
nothing beyond what those two rules say.

A JSON file has no comments, so its carrier is an ignored top-level property that the carrier registry names (`//`, or `$comment` for a JSON
Schema): the first property of the object, holding the same `catzc` block as text. A sub-agent is a robot: its file's body, everything after
the front matter, has at most `roofs.agent_body_lines` lines, 20, declared once on `AgentsConfig` and set in `agents.yml`.
