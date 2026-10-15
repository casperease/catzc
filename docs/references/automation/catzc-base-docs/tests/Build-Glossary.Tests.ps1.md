---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md
    kind: test-asset
    body_sha: c35277840372
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Build-Glossary' -Tag 'L0', 'logic' {`.

```text
Build-Glossary renders the merged glossary into one markdown page. The logic tests mock the three inputs — the
glossary (real GlossaryEntry/GlossaryConcept/GlossaryOptions types), the ADR citation map (a real AdrCitationMap
over a fixture ADR), and the adrs.yml domains — and write into $TestDrive. Fixture terms and codes are neutral
(widget/gadget, tst — [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Build-Glossary — generated glossary page' -Tag 'L1', 'integrity',...`.

```text
The real glossary page against the real sources. The importer's janitor materialises the
[glossary](/docs/adr/glossary.md) (committed and rebuilt, like the ADR index), so a current page means the generator, the sources, and the ADR citations agree. Reads only the
repository's files — the same answer in both run modes, so the build run skips it.
```
