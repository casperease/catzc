---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - TDR-STORES-VERSIONCONTROLLEDREPOSITORY
      - TDR-NORMALFORM-ANYCODEHASNORMALFORM
---

# The version controlled repository is the source of truth and all its content is code

This article is one rule:
[TDR-STORES-VERSIONCONTROLLEDREPOSITORY](../../drs/thesis/truth-stores.md#rule-tdr-stores-versioncontrolledrepository) and
[TDR-NORMALFORM-ANYCODEHASNORMALFORM](../../drs/thesis/eac-normal-form.md#rule-tdr-normalform-anycodehasnormalform) merged into one. It
holds nothing beyond what those two rules say.

A version-controlled repository is the kind of truth store whose content is a versioned history of reviewed changes; a git repository is one
subgroup of it. Inside a responsibility domain it is the source of truth, and everything inside the domain is code, managed through the one
change process. So any code can be brought into an eac normal form.
