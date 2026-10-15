---
catzc:
  derived:
    path: docs/references/automation/catzc-base-engines/configs/glossary.yml.md
    kind: comment-page
    body_sha: bd8e9e4606e4
    adrs:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Base.Engines/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Base.Engines glossary source: the vocabulary of the execution engine model this module owns
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted: all five checks, the
whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
