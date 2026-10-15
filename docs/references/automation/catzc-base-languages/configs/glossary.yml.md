---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/configs/glossary.yml.md
    kind: comment-page
    body_sha: c83e76a553ce
    adrs:
      - ADR-REPO-VOCAB#2
    links: []
---

# automation/Catzc.Base.Languages/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Base.Languages glossary source: the vocabulary of the test languages beside PowerShell that
this module owns — the Go test layout and the class of track it lives in
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted: all five checks, the
whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
