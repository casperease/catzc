---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT-ONEREADER
      - ADR-REPO-CONTRACT-NODOTFOLDERS
---

# One reader parses a command contract and contracts hold no dot folders

This article is one rule: [ADR-REPO-CMDCONTRACT-ONEREADER](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader)
and [ADR-REPO-CONTRACT-NODOTFOLDERS](../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders) merged into one. It holds
nothing beyond what those two rules say.

One reader, `Get-CommandContract`, parses a command contract into the typed record of the contract language, and nothing else parses it.
`contracts/` holds no dot-prefixed folder at any depth: a dot prefix marks infrastructure at the repository root, and every folder under
`contracts/` is content, a unit, a version, a module or a folder of an asset's path.
