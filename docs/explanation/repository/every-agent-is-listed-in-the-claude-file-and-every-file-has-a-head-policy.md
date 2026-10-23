---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-AGENTS-LISTEDINCLAUDEFILE
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# Every agent is listed in the claude file and every file has a head policy

This article is one rule:
[ADR-REPO-AGENTS-LISTEDINCLAUDEFILE](../../drs/repository/agent-definitions.md#rule-adr-repo-agents-listedinclaudefile) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

Two inventories keep the repository honest. Every registered agent is listed in the `## Sub-agents` section of `.claude/CLAUDE.md`, as a
bullet opening with its name in bold code, and the section lists no agent the registry lacks. Every file on disk is format-managed: a
`Format-*` command covers it and decides its head policy, and a file no format command covers is a finding. The default is no head; a
generated file carries the head with the do-not-edit warning.
