---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-NODOTFOLDERS
      - ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE
---

# Contracts hold no dot folders and a command contract is written in yaml (ADR-REPO-CONTRACT-NODOTFOLDERS + ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE)

This article is one rule: [ADR-REPO-CONTRACT-NODOTFOLDERS](../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders) and
[ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage) merged into
one. It holds nothing beyond what those two rules say.

`contracts/` holds no dot-prefixed folder at any depth, since every folder under it is content: a unit, a version, a module or a folder of
an asset's path. The notation a command contract is written in is YAML with a `parameters:` map, one entry per parameter whose value is one
string, the type followed by `!` when the parameter is mandatory, by `= <literal>` for a constant default, or by `pipeline` when its value
comes from the pipeline.
