---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-README-AUTHOREDSOURCES
      - ADR-REPO-FILEMETA-ROLE
---

# Authored sources live under docs references and a files role is derived

This article is one rule: [ADR-REPO-README-AUTHOREDSOURCES](../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)
and [ADR-REPO-FILEMETA-ROLE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-role) merged into one. It holds nothing beyond what
those two rules say.

Authored sources live under `docs/references/`: pwsh modules as the responsibilities-first reference articles in
`docs/references/pwsh/<kebab>.md`, and other folders under `docs/references/` as well. The one mapping outside it is `docs/drs/`. The role
of a file, the part it plays, is derived on demand and never written into a head.
