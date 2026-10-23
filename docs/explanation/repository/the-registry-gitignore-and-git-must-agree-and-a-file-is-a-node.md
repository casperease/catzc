---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-ROOTCFG-THREEWAYAGREEMENT
      - ADR-REPO-FILEMETA-FILEISNODE
---

# The registry gitignore and git must agree and a file is a node

This article is one rule:
[ADR-REPO-ROOTCFG-THREEWAYAGREEMENT](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-threewayagreement) and
[ADR-REPO-FILEMETA-FILEISNODE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode) merged into one. It holds nothing beyond
what those two rules say.

The registry, `.gitignore` and git's tracked set must agree, and an integrity test asserts it: every opted-in `committed: false` target is
matched by an ignore rule and untracked, every `committed: true` target is tracked and not ignored, and a generator target matches its
generator's output. A file is a node, and its meta block says two things about it, `immutable` holding the place facts a reader of the head
needs.
