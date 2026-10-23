---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-NODOTFOLDERS
      - ADR-REPO-CMDCONTRACT-VERSIONSWITHUNIT
---

# Contracts hold no dot folders and a command contract versions with its unit

This article is one rule: [ADR-REPO-CONTRACT-NODOTFOLDERS](../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders) and
[ADR-REPO-CMDCONTRACT-VERSIONSWITHUNIT](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-versionswithunit) merged into
one. It holds nothing beyond what those two rules say.

`contracts/` holds no dot-prefixed folder at any depth, every folder under it being content. A command contract versions with its unit: the
draft `0.0.0` is where a signature is shaped, and a change to a contracted command's signature edits its asset in the same change, or the
check fails.
