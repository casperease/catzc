---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-SELFSERV-REPOSITORYISSOURCEOFTRUTH
      - DDR-THINPLAT-REPRESENTEDASCODE
---

# The repository is the single source of truth and everything is represented as code

This article is one rule:
[DDR-SELFSERV-REPOSITORYISSOURCEOFTRUTH](../../drs/design/self-service.md#rule-ddr-selfserv-repositoryissourceoftruth) and
[DDR-THINPLAT-REPRESENTEDASCODE](../../drs/design/thin-platforms.md#rule-ddr-thinplat-representedascode) merged into one. It holds nothing
beyond what those two rules say.

The repository is the single source of truth for everything the platform manages, automation, configuration, infrastructure and pinned
tooling, all represented as code in exactly one living version. Self-service means editing that source and letting the platform apply it; it
never means clicking a portal or running an out-of-band command, so there is no console-clicked state and no out-of-band tooling.
