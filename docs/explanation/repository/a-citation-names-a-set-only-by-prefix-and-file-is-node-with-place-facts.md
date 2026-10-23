---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-DRSCODE-NOSUBSETSPELLING
      - ADR-REPO-FILEMETA-FILEISNODE
---

# A citation names a set only by prefix and file is node with place facts

This article is one rule:
[ADR-REPO-DRSCODE-NOSUBSETSPELLING](../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-nosubsetspelling) and
[ADR-REPO-FILEMETA-FILEISNODE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode) merged into one. It holds nothing beyond
what those two rules say.

A citation names a set only by a prefix: there is no group, list or range syntax inside a code, and several facts are several codes. A list
that a tool derives writes a code that covers every rule of an ADR as the ADR's code, while hand-written prose never collapses. A file is a
node, and its meta block says two things about it, each in a part of its own, with `immutable` holding the place facts a reader needs.
