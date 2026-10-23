---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-LANG-DERIVEDLIVESET
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# The live identity set is derived from config and every file has a head policy (ADR-REPO-LANG-DERIVEDLIVESET + ADR-REPO-FILEMETA-HEADPOLICY)

This article is one rule:
[ADR-REPO-LANG-DERIVEDLIVESET](../../drs/repository/domain-language-separation.md#rule-adr-repo-lang-derivedliveset) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

Nothing is hand-listed where it can be derived. The forbidden live-identity set is derived from the shipped config, `Get-LiveIdentityTokens`
reading `customer.yml`, `azure.yml`, `ado.yml` and the shipped templates, so a new customer is immediately banned from logic tests. Files
follow the same discipline: every file on disk is format-managed, a `Format-*` command covers it and decides its head policy, and a file no
format command covers is a finding.
