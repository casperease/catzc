# pwsh/Base.Docs/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `concepts:`, written with `#`.

```text
glossary.yml — the Catzc.Base.Docs glossary source: the repository-wide vocabulary this module owns, the words
for the ADRs themselves ([ADR-REPO-VOCAB](/docs/drs/repository/controlled-vocabulary.md)). Every option is defaulted:
all five checks, the whole repository, every text surface
([ADR-REPO-VOCAB-GLOSSARYSOURCE](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)). Checked by Test-Glossary.
```

## comment:2

Above `forms: [language, design, test, live, landing, dns, availability]`, written with `#`.

```text
landing, dns and availability are Azure's own terms (a CAF landing zone, a private DNS zone, an availability zone), not
language zones.
```
