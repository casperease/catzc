---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md
    kind: comment-page
    body_sha: "285f9cb49eaa"
    adrs:
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `'!**/README.md'`.

```text
Generated READMEs (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
copies whose authored source under docs/ is what is linted — linting the copy would
double-report the source. See
[ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
```

## comment:7

Above `'!docs/adr/index.md'`.

```text
[index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact whose source
(adrs.yml + the generator's prose) is what is linted, not the projection.
```

## comment:8

Above `'!docs/adr/glossary.md'`.

```text
[glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
derived; the generator emits it already formatted.
```
