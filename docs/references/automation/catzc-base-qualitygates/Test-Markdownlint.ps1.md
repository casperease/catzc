---
catzc:
  immutable:
    with_body_sha: ce14b3039bd8
    path: docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: test-markdownlint-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `'!**/README.md'`, written with `#`.

```text
Generated READMEs (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
copies whose authored source under docs/ is what is linted — linting the copy would
double-report the source. See
[ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
```

## comment:2

Above `'!docs/adr/index.md'`, written with `#`.

```text
[index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact whose source
(adrs.yml + the generator's prose) is what is linted, not the projection.
```

## comment:3

Above `'!docs/adr/glossary.md'`, written with `#`.

```text
[glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
derived; the generator emits it already formatted.
```
