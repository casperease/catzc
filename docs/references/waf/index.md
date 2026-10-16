---
catzc:
  immutable:
    with_body_sha: "1c89ab77c942"
    repo_status: clean
    path: docs/references/waf/index.md
    folder: docs/references/waf
    name: index
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AZ-WAFRE#4
    links:
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/waf/
      - docs/adr/azure/waf/cost-optimization.md
      - docs/adr/azure/waf/operational-excellence.md
      - docs/adr/azure/waf/performance-efficiency.md
      - docs/adr/azure/waf/reliability.md
      - docs/adr/azure/waf/security.md
      - docs/references/dora/index.md
      - "https://learn.microsoft.com/en-us/azure/well-architected/"
      - "https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/checklist"
      - "https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist"
      - "https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist"
      - "https://learn.microsoft.com/en-us/azure/well-architected/reliability/checklist"
      - "https://learn.microsoft.com/en-us/azure/well-architected/security/checklist"
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

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

| Pillar                 | Checklist codes | Microsoft's checklist                                                                                                         |
| ---------------------- | --------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Reliability            | RE:01–RE:10     | [reliability checklist](https://learn.microsoft.com/en-us/azure/well-architected/reliability/checklist)                       |
| Security               | SE:01–SE:12     | [security checklist](https://learn.microsoft.com/en-us/azure/well-architected/security/checklist)                             |
| Cost Optimization      | CO:01–CO:14     | [cost optimization checklist](https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/checklist)           |
| Operational Excellence | OE:01–OE:11     | [operational excellence checklist](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist) |
| Performance Efficiency | PE:01–PE:12     | [performance efficiency checklist](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist) |

## How the repository answers it

Each pillar is one ADR in the `azure` domain, under [docs/adr/azure/waf/](../../adr/azure/waf/), and each checklist item is one numbered
rule whose number is Microsoft's: RE:04 is `ADR-AZ-WAFRE#4`. A rule says what this repository does about the item; its section cites
Microsoft's guide page, summarises the recommendation in our words, says what it means for the templates `foundation`, `discovery`, and
`expedition`, and ends with a status: realised, partly realised, planned (follow-up), or not adopted, with the reason.

| Pillar                 | ADR                                                                     | Code           |
| ---------------------- | ----------------------------------------------------------------------- | -------------- |
| Reliability            | [reliability](../../adr/azure/waf/reliability.md)                       | `ADR-AZ-WAFRE` |
| Security               | [security](../../adr/azure/waf/security.md)                             | `ADR-AZ-WAFSE` |
| Cost Optimization      | [cost-optimization](../../adr/azure/waf/cost-optimization.md)           | `ADR-AZ-WAFCO` |
| Operational Excellence | [operational-excellence](../../adr/azure/waf/operational-excellence.md) | `ADR-AZ-WAFOE` |
| Performance Efficiency | [performance-efficiency](../../adr/azure/waf/performance-efficiency.md) | `ADR-AZ-WAFPE` |

The landing-zone decision record ([landing-zones](../../adr/azure/landing-zones.md), `ADR-AZ-LZ`) carries the one-line-per-pillar summary of
how `expedition` realises the framework; the pillar ADRs are the item-by-item account behind it.

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
