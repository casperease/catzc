# pwsh/Base.Engines/configs/glossary.yml

The glossary source of the engines module: the vocabulary of the execution engine model this module owns
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)). `Test-Glossary` checks it.

## Options

Every option takes its default: all five checks, the whole repository and every text surface
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). The file declares
only the engine vocabulary and never narrows what the checks read.
