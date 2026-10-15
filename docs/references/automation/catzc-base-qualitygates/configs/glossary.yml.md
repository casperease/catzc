---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/glossary.yml.md
    kind: comment-page
    body_sha: "2b2bcac454ea"
    adrs:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Base.QualityGates/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Base.QualityGates glossary source: the vocabulary of the quality gates this module owns — the
test vocabulary of Test-Automation and the link vocabulary of Test-Links ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted: all five
checks, the whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
