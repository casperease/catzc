---
catzc:
  config:
    pattern: pair
    deck: product-thesis
    order: 6
---

# The repository is the configuration record, and it answers

## Eyebrow

TDR-ONETRUTH-REPOSITORYISRECORD and TDR-ONETRUTH-TRUTHISQUERYABLE · Mechanics

## Cards

- **No second database** Infrastructure is reproducible from a commit, so the code takes the place of the CMDB. Nothing about delivery state
  has its source of truth (for BVT) outside the repository.
- **Answers as data** Every Get cmdlet reads the repository and returns a typed answer, and emits it as JSON, so a service-management tool
  reads the truth without PowerShell.

## Body

One adjacent store is allowed, such as a GitOps or configuration repository, or Azure DevOps Services or GitHub SaaS, driven one way from
the trunk's pipelines and never edited beside it: a projection of the truth, never a second record.

## Notes

Rules two and three. The code replaces the CMDB, the tooling replaces the second database that would answer queries, and the one allowed
second store is a projection the pipelines write.
