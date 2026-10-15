---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/glossary.yml.md
    kind: comment-page
    body_sha: "748acdcbb126"
    adrs:
      - ADR-REPO-VOCAB#2
    links: []
---

# automation/Catzc.Base.ModuleSystem/configs/glossary.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `concepts:`.

```text
glossary.yml — the Catzc.Base.ModuleSystem glossary source: the vocabulary of what ships and how it advances —
deployable-units, the release candidates built from them, and the environments' occupants ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)).
Every option is defaulted: all five checks, the whole repository, every text surface
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). Checked by Test-Glossary.
```
