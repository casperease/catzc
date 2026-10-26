# pwsh/Base.Docs/types/GlossaryConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One glossary source (a module's configs/glossary.yml) — the controlled vocabulary that module opts into
([ADR-REPO-VOCAB](/docs/drs/repository/controlled-vocabulary.md)). Constructing an instance MAPS and VALIDATES the
parsed YAML, collecting every violation into one throw, and exposes the defaulted `options` (GlossaryOptions) and
the `concepts` (GlossaryConcept, in source order). Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Docs.GlossaryConfig), so Get-Config -Config glossary -Module <owner> returns this typed model.

Load-time rules are self-contained — this one file only, no filesystem, git, or other-config reads:
  - only the top-level keys 'options' (optional) and 'concepts' (a non-empty map keyed by term);
  - every concept is well-formed (GlossaryConcept) and its machine key is unique within the source;
  - no avoided phrase equals a term the source defines (a term cannot be both canonical and avoided);
  - no value anywhere in the source is a URL — every source and every reference it makes stays in the
    repository ([ADR-REPO-VOCAB-SOURCESINREPOSITORY](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)).
Cross-source and cross-file facts — term/key uniqueness across all sources, reciprocal contrasts, a defined_by
that names a real rule, a domain that drs.yml declares, a tracked source file — are the glossary gates' job
(Test-Glossary), not load's, so loading stays hermetic (the
[ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) pattern).
```
