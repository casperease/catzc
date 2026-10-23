---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-ROOTCFG-REGISTRY
      - ADR-REPO-FILEMETA-FILEISNODE
---

# The root config registry is opt out by default and file node with place facts

This article is one rule: [ADR-REPO-ROOTCFG-REGISTRY](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-registry) and
[ADR-REPO-FILEMETA-FILEISNODE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode) merged into one. It holds nothing beyond
what those two rules say.

The root-config registry is `rootconfig.yml`, materialised by `Build-RootConfig`, the single writer; opt-out is the default, so an entry not
opted in stays hand-authored and committed, and `optIn: true` is the explicit takeover switch. A file is a node, and its meta block says two
things about it, each in a part of its own: `immutable` holds the place facts a reader needs, and only a generated head has any.
