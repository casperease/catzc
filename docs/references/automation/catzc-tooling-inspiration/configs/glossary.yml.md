---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/configs/glossary.yml.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a7da309b074e
    adrs:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Tooling.Inspiration/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `concepts:`, written with `#`.

```text
glossary.yml — the Catzc.Tooling.Inspiration glossary source: the vocabulary of the inspirations this module declares
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
