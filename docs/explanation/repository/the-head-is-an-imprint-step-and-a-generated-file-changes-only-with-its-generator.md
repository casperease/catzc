---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CODEMETA-IMPRINTSTEP
      - ADR-REPO-FILEMETA-INTUNEWITHGENERATOR
---

# The head is an imprint step and a generated file changes only with its generator

This article is one rule: [ADR-REPO-CODEMETA-IMPRINTSTEP](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-imprintstep) and
[ADR-REPO-FILEMETA-INTUNEWITHGENERATOR](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-intunewithgenerator) merged into one. It
holds nothing beyond what those two rules say.

`Format-Code` writes the head as an imprint step: the step is global, the file-language registry listing it once so it runs after the
formatter of every language. A generated file changes only in tune with its generator: rendering the file from the tree at hand gives
exactly the bytes on disk, and a hand edit, or a generator input changed without the file rendered anew, is not legal.
