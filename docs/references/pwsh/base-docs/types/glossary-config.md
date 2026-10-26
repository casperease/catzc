# pwsh/Base.Docs/types/GlossaryConfig.cs

One glossary source (a module's glossary config): the controlled vocabulary that module opts into
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)). Constructing an instance maps and validates the parsed YAML,
collecting every violation into one throw, and exposes the defaulted `options` ([GlossaryOptions](glossary-options.md)) and the `concepts`
([GlossaryConcept](glossary-concept.md), in source order). It is registered in `Catzc.Base.Config/configs/configs.yml`, so
`Get-Config -Config glossary -Module <owner>` returns this typed model.

## Load-time rules

The rules are self-contained, this one source only, with no filesystem, git or other-config reads:

- only the top-level keys `options` (optional) and `concepts` (a non-empty map keyed by term);
- every concept is well-formed and its machine key is unique within the source;
- no avoided phrase equals a term the source defines, since a term cannot be both canonical and avoided;
- no value anywhere in the source is a URL, so every source and every reference it makes stays in the repository
  ([ADR-REPO-VOCAB-SOURCESINREPOSITORY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)).

Cross-source and cross-file facts are the glossary checks' job (`Test-Glossary`), not load's: term and key uniqueness across all sources,
reciprocal contrasts, a `defined_by` that names a real rule, a domain that `drs.yml` declares, a tracked source file. Loading stays hermetic
(the [ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)
pattern).
