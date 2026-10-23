---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE
      - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
---

# Deploy governs an environment and change is computed from git at real refs (FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE + FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT)

This article is one rule: [FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-deploycarriesgovernance)
and [FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT](../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-changecomputedfromgit) merged into one. It
holds nothing beyond what those two rules say.

DEPLOY exists to make an environment's governance a first-class pipeline construct, one place for access control, isolation and audit
history over an environment behind a manual gate, and it splits by target on the one build-once artifact. What it deploys is decided by git:
whether a change touches a unit is computed at real refs, never from a committed hash, by `Get-ChangedGlobSet` diffing a commit range and
matching the changed paths against the registry.
