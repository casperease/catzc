---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
---

# A command contract stores no placement facts and a code head holds two edges

This article is one rule:
[ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts) and
[ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-computablefactsonly) merged into one.
It holds nothing beyond what those two rules say.

A command contract stores nothing its placement says: the command's name is the file name, the owning module is the folder, and the version
is the unit's version folder. An authored code or config file's head follows the same economy: it is the navigation head and holds exactly
two edges under `edges`, `cites` and `docs`.
