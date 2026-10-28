# Azure Well-Architected Framework reference

This folder is the repository's local entry point to Microsoft's
[Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) (WAF): what it is, how it is organised, and
where each of its recommendations is answered here. WAF is **vendor recommendation**, not principled theory: the DORA research
([DORA reference](../dora/index.md)) explains why this repository works the way it does; WAF is one vendor's checklist for building a
workload on Azure, which the repository adopts, adapts, or declines item by item, with the reason.

## What the framework is

WAF describes a workload's quality as five pillars and gives each pillar a design review checklist: a numbered set of recommendations
(RE:01, SE:04, …), each linked to a guide page that explains it. A team reviews its design against the checklists, decides what to adopt,
and records the trade-offs between pillars.

| Pillar                 | Checklist codes | Microsoft's checklist                  |
| ---------------------- | --------------- | -------------------------------------- |
| Reliability            | RE:01–RE:10     | [reliability checklist][re]            |
| Security               | SE:01–SE:12     | [security checklist][se]               |
| Cost Optimization      | CO:01–CO:14     | [cost optimization checklist][co]      |
| Operational Excellence | OE:01–OE:11     | [operational excellence checklist][oe] |
| Performance Efficiency | PE:01–PE:12     | [performance efficiency checklist][pe] |

[re]: https://learn.microsoft.com/en-us/azure/well-architected/reliability/checklist
[se]: https://learn.microsoft.com/en-us/azure/well-architected/security/checklist
[co]: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/checklist
[oe]: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist
[pe]: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist

## How the repository answers it

Each pillar is one decision record in the `azure` domain, under [docs/drs/external/azure/waf/](../../drs/external/azure/waf/), and each
checklist item is one numbered rule whose number is Microsoft's: RE:04 is `EDR-AZ-WAF-RE-RE04`. A rule says what this repository does about
the item; its section cites Microsoft's guide page, summarises the recommendation in our words, says what it means for the templates
`foundation`, `discovery`, and `expedition`, and ends with a status: realised, partly realised, planned (follow-up), or not adopted, with
the reason.

| Pillar                 | Record                                                                           | Code            |
| ---------------------- | -------------------------------------------------------------------------------- | --------------- |
| Reliability            | [reliability](../../drs/external/azure/waf/reliability.md)                       | `EDR-AZ-WAF-RE` |
| Security               | [security](../../drs/external/azure/waf/security.md)                             | `EDR-AZ-WAF-SE` |
| Cost Optimization      | [cost-optimization](../../drs/external/azure/waf/cost-optimization.md)           | `EDR-AZ-WAF-CO` |
| Operational Excellence | [operational-excellence](../../drs/external/azure/waf/operational-excellence.md) | `EDR-AZ-WAF-OE` |
| Performance Efficiency | [performance-efficiency](../../drs/external/azure/waf/performance-efficiency.md) | `EDR-AZ-WAF-PE` |

The landing-zone decision record ([landing-zones](../../drs/azure/landing-zones.md), `ADR-AZ-LZ`) carries the one-line-per-pillar summary of
how `expedition` realises the framework; the pillar records are the item-by-item account behind it.

## Citation, not quotation

The rules cite Microsoft's pages and summarise them in our own words; nothing is quoted. The current WAF pages are published from a private
Microsoft repository, so no reuse licence covers their text, and the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse) do not allow copying it into a shared repository. An
older copy of the framework was published under CC BY 4.0, but it predates the numbered checklists and does not match them. Each rule's
citation names the guide page it summarises and the date it was read.

## Retrieval and refresh

The checklists and guide pages were read on **2026-10-15**. Microsoft revises the framework without notice: a refresh reads the five
checklist pages again, compares their codes and titles with the rules, and updates the summary and the takeaways of any item whose
recommendation changed. A new checklist item is a new rule with Microsoft's number; a withdrawn item keeps its rule, marked as withdrawn
with the date, so a citation of it never points at nothing.
