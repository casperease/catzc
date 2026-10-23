---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-INTUNEWITHGENERATOR
      - ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE
---

# A generated file changes only in tune with its generator and contracts use small language

This article is one rule:
[ADR-REPO-FILEMETA-INTUNEWITHGENERATOR](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-intunewithgenerator) and
[ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage) merged into
one. It holds nothing beyond what those two rules say.

A generated file changes only in tune with its generator: rendering the file from the tree at hand gives exactly the bytes on disk, and a
change to the file or to an input of its generator is legal when the writer has rendered the file again. A command contract is written in a
small notation: YAML with a `parameters:` map, one string per parameter, the type followed by `!` when mandatory.
