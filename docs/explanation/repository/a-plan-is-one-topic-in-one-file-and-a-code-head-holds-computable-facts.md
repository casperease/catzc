---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-PLANS-ONETOPICONEFILE
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
---

# A plan is one topic in one file and a code head holds computable facts

This article is one rule: [ADR-REPO-PLANS-ONETOPICONEFILE](../../drs/repository/plans.md#rule-adr-repo-plans-onetopiconefile) and
[ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-computablefactsonly) merged into one.
It holds nothing beyond what those two rules say.

A plan is one topic in one file, `.claude/plans/plan-<topic>.md`, authored directly there, and it holds the delta only: what is still open
and what was decided and why. A code or config file's head follows the same restraint: the navigation head holds exactly two edges, `cites`,
the rule codes that bind the file, and `docs`, the link to its comment page.
