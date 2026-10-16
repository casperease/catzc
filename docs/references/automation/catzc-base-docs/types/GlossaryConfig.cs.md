---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/GlossaryConfig.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b8ea5cda5305
    adrs:
      - ADR-AZ-CUSTOMER#3
      - ADR-REPO-VOCAB#3
---

# automation/Catzc.Base.Docs/types/GlossaryConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One glossary source (a module's configs/glossary.yml) — the controlled vocabulary that module opts into
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Constructing an instance MAPS and VALIDATES the
parsed YAML, collecting every violation into one throw, and exposes the defaulted `options` (GlossaryOptions) and
the `concepts` (GlossaryConcept, in source order). Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Docs.GlossaryConfig), so Get-Config -Config glossary -Module <owner> returns this typed model.

Load-time rules are self-contained — this one file only, no filesystem, git, or other-config reads:
  - only the top-level keys 'options' (optional) and 'concepts' (a non-empty map keyed by term);
  - every concept is well-formed (GlossaryConcept) and its machine key is unique within the source;
  - no avoided phrase equals a term the source defines (a term cannot be both canonical and avoided);
  - no value anywhere in the source is a URL — every source and every reference it makes stays in the
    repository ([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)).
Cross-source and cross-file facts — term/key uniqueness across all sources, reciprocal contrasts, a defined_by
that names a real rule, a domain that adrs.yml declares, a tracked source file — are the glossary gates' job
(Test-Glossary), not load's, so loading stays hermetic (the
[ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern).
```
