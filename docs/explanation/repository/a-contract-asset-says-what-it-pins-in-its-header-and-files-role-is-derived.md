---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS
      - ADR-REPO-FILEMETA-ROLE
---

# A contract asset says what it pins in its header and files role is derived

This article is one rule:
[ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS](../../drs/repository/api-contracts.md#rule-adr-repo-contract-headersayswhatitpins) and
[ADR-REPO-FILEMETA-ROLE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-role) merged into one. It holds nothing beyond what those
two rules say.

An asset says what it pins in its own header comment, the leading `#` lines of a YAML asset or the `$comment` of a schema, and `contracts/`
holds only assets; `Build-ContractReference` generates one committed page per unit. The role of a file, the part it plays such as a test, a
function, a config or a decision record, is derived on demand and never written into a head.
