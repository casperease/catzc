---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Build-TerminologyDictionary.Tests.ps1.md
    kind: test-asset
    body_sha: "7849b7fe6bb6"
---

# automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.QualityGates {`.

```text
A tiny registry spanning all three categories, with a duplicate and mixed case in the product
category, to prove per-category grouping plus lower-casing + de-duplication.
```

## comment:2

Above `Describe 'Build-TerminologyDictionary — real registry' -Tag 'L2',...`.

```text
source-only: it compares the repository's generated .cspell/ dictionaries with the registry, which gives the
same answer in both run modes.
```
