---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-HELP-CITATIONINSENTENCE
      - ADR-REPO-FILEMETA-ROLE
---

# A citation may stand in a help sentence while a files role is derived

This article is one rule: [ADR-REPO-HELP-CITATIONINSENTENCE](../../drs/repository/function-help.md#rule-adr-repo-help-citationinsentence)
and [ADR-REPO-FILEMETA-ROLE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-role) merged into one. It holds nothing beyond what
those two rules say.

A citation may stand inside a help sentence, where it names the rule the sentence rests on; the rule codes a function rests on are derived
from the file and its page, so the help never lists them. In the same spirit the role of a file, the part it plays such as a test, a
function, a config or a decision record, is derived on demand and never written into a head.
