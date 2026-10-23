---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FOLDERS-DOTMEANSTOOLING
      - ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS
---

# A dot prefix means tooling and module globsets are derived never declared

This article is one rule:
[ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../drs/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling) and
[ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets) merged into
one. It holds nothing beyond what those two rules say.

Dot-prefix means infrastructure or tooling, everywhere, and under `pwsh/` it is enforced mechanically by `Import-AllModules`. Module
globsets are derived, never declared: every module folder under `pwsh/` derives a set named by the readme-kebab convention,
`Catzc.Base.Globs` becoming `catzc-base-globs` with include `pwsh/<Module>/**`.
