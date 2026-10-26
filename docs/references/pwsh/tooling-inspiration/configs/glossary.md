# pwsh/Tooling.Inspiration/configs/glossary.yml

The glossary source of the Tooling.Inspiration module: the vocabulary of the inspirations it declares
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)).

## Options

Every option takes its default, so the source declares only the inspiration vocabulary and never narrows what the checks read
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). `Test-Glossary`
checks it.
