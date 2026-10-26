# pwsh/Base.Docs/types/GlossaryOptions.cs

A glossary source's parameters (the optional `options:` mapping), with every key defaulted, so a source overrides only what differs
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). It mirrors the YAML
mapping, snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

- **`checks`** — which glossary checks the source's concepts take part in; the structural check always runs.
- **`scope`** and **`exclude`** — where its avoided phrasings are scanned. The default excludes (external language, generated output, vendored
  code) are always added to a source's own, so no source can scan DORA's research text or `out/`.
- **`surfaces`** — which kinds of text are read there.

Scope and exclude globs are repo-relative: '/'-separated, no leading '/', no drive, no '..', never a URL
([ADR-REPO-VOCAB-SOURCESINREPOSITORY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)).

## Closed lists

A list option restricted to a closed set takes the whole set when absent. An explicit empty list is allowed: a source that opts out of every
check still gets the structural check.
