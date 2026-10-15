---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossarySourceViolations.ps1.md
    kind: reference
    body_sha: "79c78963d170"
    adrs:
      - ADR-REPO-VOCAB#1
      - ADR-REPO-VOCAB#3
      - ADR-REPO-VOCAB#4
      - ADR-REPO-VOCAB#5
---

# automation/Catzc.Base.Docs/private/Get-GlossarySourceViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The GlossaryConfig type checks each source on its own when it loads; this checks what no single source can
see ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)):
  - a term defined by two sources, or a machine key used by two
  ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1));
  - a domain that adrs.yml does not declare
  ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1));
  - an avoided phrase that is another source's term
  ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5));
  - a contrast or relation target that no source defines
  ([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3));
  - a contrast that is not reciprocal — A contrasts B, but B does not contrast A
  ([ADR-REPO-VOCAB#4](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab4));
  - a source that git does not track
  ([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)).
The first source in owner order keeps a duplicated term or key; every later one is reported. Each message
starts with the repo-relative path of the source it reports and names the term, so it points at the line to fix.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER Source` of the comment-based help.

```text
The glossary sources, as Get-GlossarySources returns them ({ Owner; Path; Config; Tracked }). Defaults to
every source in the repository.
```
