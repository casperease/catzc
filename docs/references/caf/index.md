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

Each design area is a decision record in the `azure` domain, under [docs/drs/external/azure/caf/](../../drs/external/azure/caf/); the
network design area, the largest, is split into three. Each design recommendation is one numbered rule, numbered in the order Microsoft's
pages list them; its section cites the page, summarises the recommendation in our words, says what it means for the templates `foundation`,
`discovery`, and `expedition`, and ends with a status: realised, partly realised, planned (follow-up), or not adopted, with the reason. A
recommendation that touches no template, config, module, pipeline, or check of this repository (a billing agreement type, another cloud) is
recorded in a compact form that says why it does not apply.

| Design area                        | Record                                                                           | Code                |
| ---------------------------------- | -------------------------------------------------------------------------------- | ------------------- |
| Design principles                  | [design-principles](../../drs/external/azure/caf/design-principles.md)           | `EDR-AZ-CAF-PRIN`   |
| Billing and Microsoft Entra tenant | [billing-and-tenant](../../drs/external/azure/caf/billing-and-tenant.md)         | `EDR-AZ-CAF-BILL`   |
| Identity and access management     | [identity-and-access](../../drs/external/azure/caf/identity-and-access.md)       | `EDR-AZ-CAF-IAM`    |
| Resource organization              | [resource-organization](../../drs/external/azure/caf/resource-organization.md)   | `EDR-AZ-CAF-RESORG` |
| Network topology                   | [network-topology](../../drs/external/azure/caf/network-topology.md)             | `EDR-AZ-CAF-NETTOP` |
| Network connectivity               | [network-connectivity](../../drs/external/azure/caf/network-connectivity.md)     | `EDR-AZ-CAF-NETCON` |
| Private access to PaaS and DNS     | [network-private-access](../../drs/external/azure/caf/network-private-access.md) | `EDR-AZ-CAF-NETPRV` |
| Security                           | [landing-zone-security](../../drs/external/azure/caf/landing-zone-security.md)   | `EDR-AZ-CAF-SEC`    |
| Management                         | [management](../../drs/external/azure/caf/management.md)                         | `EDR-AZ-CAF-MGMT`   |
| Governance                         | [governance](../../drs/external/azure/caf/governance.md)                         | `EDR-AZ-CAF-GOV`    |
| Platform automation and DevOps     | [platform-automation-and-devops][devops]                                         | `EDR-AZ-CAF-DEVOPS` |
| Naming and tagging                 | [naming-and-tagging](../../drs/external/azure/caf/naming-and-tagging.md)         | `EDR-AZ-CAF-NAME`   |

[devops]: ../../drs/external/azure/caf/platform-automation-and-devops.md

The landing-zone decision record ([landing-zones](../../drs/azure/landing-zones.md), `ADR-AZ-LZ`) is this repository's own decision; the CAF
records account for each vendor recommendation against it. The workload-side counterpart is the
[Well-Architected Framework reference](../waf/index.md).

## Citation, not quotation

The rules cite Microsoft's pages and summarise them in our own words; nothing is quoted. The live CAF pages are published from a private
Microsoft repository, and the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse) apply to them. A public
mirror of the framework carries CC BY 4.0, but the live pages are not confirmed to match it, so the rules cite the live pages and quote none
of them.

## Retrieval and refresh

The pages were read on **2026-10-14 and 2026-10-15** (each rule's citation carries its own date). Microsoft restructures CAF pages from time
to time — several design-area pages have replaced their "design recommendations" sections with other guidance. A refresh reads each cited
page again, updates the summary and takeaways of any changed recommendation, adds a new recommendation as a new rule at the end of its
record, and keeps a withdrawn one as a rule marked withdrawn with the date, so a citation of it never points at nothing.
