---
catzc:
  immutable:
    with_body_sha: "1b864b81372e"
    path: docs/references/automation/catzc-base-qualitygates/configs/glossary.yml.md
    folder: docs/references/automation/catzc-base-qualitygates/configs
    name: glossary-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-VOCAB#2
---

# automation/Catzc.Base.QualityGates/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `concepts:`, written with `#`.

```text
glossary.yml — the Catzc.Base.QualityGates glossary source: the vocabulary of the quality gates this module owns — the
test vocabulary of Test-Automation and the link vocabulary of Test-Links ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)). Every option is defaulted: all five
checks, the whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
