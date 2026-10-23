---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-LENSPICKSPATH
      - ADR-REPO-FILEMETA-FILEISNODE
---

# The lens picks the renderer path and a file is a node with place facts

This article is one rule: [ADR-REPO-SLIDES-LENSPICKSPATH](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-lenspickspath) and
[ADR-REPO-FILEMETA-FILEISNODE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode) merged into one. It holds nothing beyond
what those two rules say.

The declaration's `about.lens` picks the renderer path: the lens `action` takes the action path and every other lens takes the band path,
both belonging to the one renderer and the one declaration format, with put, get, conflicts and the stale rebuild applying to both
unchanged. A file is likewise a node whose meta block says two things about it, `immutable` holding the place facts a reader of the head
needs.
