# pwsh/Catzc.Azure.Templates/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `concepts:`, written with `#`.

```text
glossary.yml — the Catzc.Azure.Templates glossary source: the vocabulary of the Bicep template configuration this module
builds and deploys ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted: all five
checks, the whole repository, every text surface
([ADR-REPO-VOCAB-GLOSSARYSOURCE](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). Checked by Test-Glossary.
```
