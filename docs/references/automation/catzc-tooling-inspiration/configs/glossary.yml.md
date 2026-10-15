---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/configs/glossary.yml.md
    kind: comment-page
    body_sha: a08c91659318
    adrs:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Tooling.Inspiration/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Tooling.Inspiration glossary source: the vocabulary of the inspirations this module declares
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
