---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Build-TerminologyDictionary.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "99dad272ffc3"
---

# automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.QualityGates {`, written with `#`.

```text
A tiny registry spanning all three categories, with a duplicate and mixed case in the product
category, to prove per-category grouping plus lower-casing + de-duplication.
```

## comment:2

Above `Describe 'Build-TerminologyDictionary — real registry' -Tag 'L2',...`, written with `#`.

```text
source-only: it compares the repository's generated .cspell/ dictionaries with the registry, which gives the
same answer in both run modes.
```
