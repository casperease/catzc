---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
---

# A contracts direction comes by convention and a command contract is a provided asset (ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION + ADR-REPO-CMDCONTRACT-COMMANDCONTRACT)

This article is one rule:
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention) and
[ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract) merged into one.
It holds nothing beyond what those two rules say.

A contract asset's direction comes by convention: an asset that constrains a real repository file is depended-on, and a sample payload or a
command contract is provided. A command contract is a contract asset, `<module>/<command>.command.yml` in a unit's version folder, that
states the call interface. A per-version `contract.yml` overrides the direction of a single asset.
