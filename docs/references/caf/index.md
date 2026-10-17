---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/caf/index.md
    folder: docs/references/caf
    name: index
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/azure/caf/
      - docs/adr/azure/caf/billing-and-tenant.md
      - docs/adr/azure/caf/design-principles.md
      - docs/adr/azure/caf/governance.md
      - docs/adr/azure/caf/identity-and-access.md
      - docs/adr/azure/caf/landing-zone-security.md
      - docs/adr/azure/caf/management.md
      - docs/adr/azure/caf/naming-and-tagging.md
      - docs/adr/azure/caf/network-connectivity.md
      - docs/adr/azure/caf/network-private-access.md
      - docs/adr/azure/caf/network-topology.md
      - docs/adr/azure/caf/platform-automation-and-devops.md
      - docs/adr/azure/caf/resource-organization.md
      - docs/adr/azure/landing-zones.md
      - docs/references/dora/index.md
      - docs/references/waf/index.md
      - "https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/"
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

# Cloud Adoption Framework reference

This folder is the repository's local entry point to Microsoft's
[Cloud Adoption Framework for Azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) (CAF): what part of it applies here,
how that part is organised, and where each of its recommendations is answered. CAF is **vendor recommendation**, not principled theory: the
DORA research ([DORA reference](../dora/index.md)) explains why this repository works the way it does; CAF is one vendor's guidance for
preparing an Azure estate, which the repository adopts, adapts, or declines item by item, with the reason.

## What applies here

CAF covers an organisation's whole cloud journey, from strategy to operations. This repository answers the part that shapes its configs and
infrastructure as code: the **Azure landing zone** guidance in CAF's Ready methodology — its five design principles and its design areas —
plus the naming and tagging guidance. The other methodologies (strategy, plan, adopt, govern, secure, manage as organisational practices)
are outside this repository.

## How the repository answers it

Each design area is an ADR in the `azure` domain, under [docs/adr/azure/caf/](../../adr/azure/caf/); the network design area, the largest,
is split into three. Each design recommendation is one numbered rule, numbered in the order Microsoft's pages list them; its section cites
the page, summarises the recommendation in our words, says what it means for the templates `foundation`, `discovery`, and `expedition`, and
ends with a status: realised, partly realised, planned (follow-up), or not adopted, with the reason. A recommendation that touches no
template, config, module, pipeline, or check of this repository (a billing agreement type, another cloud) is recorded in a compact form that
says why it does not apply.

| Design area                        | ADR                                                                                     | Code               |
| ---------------------------------- | --------------------------------------------------------------------------------------- | ------------------ |
| Design principles                  | [design-principles](../../adr/azure/caf/design-principles.md)                           | `ADR-AZ-CAFPRIN`   |
| Billing and Microsoft Entra tenant | [billing-and-tenant](../../adr/azure/caf/billing-and-tenant.md)                         | `ADR-AZ-CAFBILL`   |
| Identity and access management     | [identity-and-access](../../adr/azure/caf/identity-and-access.md)                       | `ADR-AZ-CAFIAM`    |
| Resource organization              | [resource-organization](../../adr/azure/caf/resource-organization.md)                   | `ADR-AZ-CAFRESORG` |
| Network topology                   | [network-topology](../../adr/azure/caf/network-topology.md)                             | `ADR-AZ-CAFNETTOP` |
| Network connectivity               | [network-connectivity](../../adr/azure/caf/network-connectivity.md)                     | `ADR-AZ-CAFNETCON` |
| Private access to PaaS and DNS     | [network-private-access](../../adr/azure/caf/network-private-access.md)                 | `ADR-AZ-CAFNETPRV` |
| Security                           | [landing-zone-security](../../adr/azure/caf/landing-zone-security.md)                   | `ADR-AZ-CAFSEC`    |
| Management                         | [management](../../adr/azure/caf/management.md)                                         | `ADR-AZ-CAFMGMT`   |
| Governance                         | [governance](../../adr/azure/caf/governance.md)                                         | `ADR-AZ-CAFGOV`    |
| Platform automation and DevOps     | [platform-automation-and-devops](../../adr/azure/caf/platform-automation-and-devops.md) | `ADR-AZ-CAFDEVOPS` |
| Naming and tagging                 | [naming-and-tagging](../../adr/azure/caf/naming-and-tagging.md)                         | `ADR-AZ-CAFNAME`   |

The landing-zone decision record ([landing-zones](../../adr/azure/landing-zones.md), `ADR-AZ-LZ`) is this repository's own decision; the CAF
ADRs account for each vendor recommendation against it. The workload-side counterpart is the
[Well-Architected Framework reference](../waf/index.md).

## Citation, not quotation

The rules cite Microsoft's pages and summarise them in our own words; nothing is quoted. The live CAF pages are published from a private
Microsoft repository, and the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse) apply to them. A public
mirror of the framework carries CC BY 4.0, but the live pages are not confirmed to match it, so the rules cite the live pages and quote none
of them.

## Retrieval and refresh

The pages were read on **2026-10-14 and 2026-10-15** (each rule's citation carries its own date). Microsoft restructures CAF pages from time
to time — several design-area pages have replaced their "design recommendations" sections with other guidance. A refresh reads each cited
page again, updates the summary and takeaways of any changed recommendation, adds a new recommendation as a new rule at the end of its ADR,
and keeps a withdrawn one as a rule marked withdrawn with the date, so a citation of it never points at nothing.
