---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-README-AUTHOREDSOURCES
      - ADR-REPO-CODEMETA-SAMEENGINE
---

# Authored sources live under docs references and a head is imprinted by the same engine

This article is one rule: [ADR-REPO-README-AUTHOREDSOURCES](../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)
and [ADR-REPO-CODEMETA-SAMEENGINE](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-sameengine) merged into one. It holds
nothing beyond what those two rules say.

Authored sources live under `docs/references/`, pwsh modules as the responsibilities-first reference articles, and other folders under
`docs/references/` as well; the one mapping outside it is `docs/drs/`. The head's `edges` part, the only part an authored head has, is
imprinted by the same engine, from the same registry, as a Markdown block.
