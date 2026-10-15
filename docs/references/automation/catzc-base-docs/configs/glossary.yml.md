---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/configs/glossary.yml.md
    kind: reference
    body_sha: "40c27be356ed"
    adrs:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Base.Docs/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Base.Docs glossary source: the repository-wide vocabulary this module owns, the words
for the ADRs themselves ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted:
all five checks, the whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```

## comment:2

Above `forms: [language, design, test, live, landing, dns, availability]`.

```text
landing, dns and availability are Azure's own terms (a CAF landing zone, a private DNS zone, an availability zone), not
language zones.
```
