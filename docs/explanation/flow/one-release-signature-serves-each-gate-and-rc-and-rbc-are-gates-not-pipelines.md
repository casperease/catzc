---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-QUEUE-SIGNATUREISTHEGATE
      - FDR-CD-TWORELEASEGATES
---

# One release signature serves each gate and rc and rbc are gates not pipelines

This article is one rule: [FDR-CD-QUEUE-SIGNATUREISTHEGATE](../../drs/flow/manual-queues.md#rule-fdr-cd-queue-signatureisthegate) and
[FDR-CD-TWORELEASEGATES](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates) merged into one. It holds nothing
beyond what those two rules say.

RC and RBC are the two hands-on release gates, each a gate and not a pipeline: RC is the gate at main-UAT and RBC the gate at release-uat.
Each is served by one release signature from a user with access, entered in the appointed security registry after the rung's post-deployment
test proved the service loads, one recorded act that says this rung passed its check for one named commit.
