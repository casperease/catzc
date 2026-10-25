# pwsh/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Build-Glossary'`, written with `#`.

```text
Build-Glossary renders the merged glossary into one markdown page. The logic tests mock the three inputs — the
glossary (real GlossaryEntry/GlossaryConcept/GlossaryOptions types), the ADR citation map (a real DrsCitationMap
over a fixture ADR), and the drs.yml domains — and write into $TestDrive. Fixture terms and codes are neutral
(widget/gadget, tst — [ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Build-Glossary — generated glossary page'`, written with `#`.

```text
The real glossary page against the real sources. The importer's janitor materialises the
[glossary](/docs/drs/glossary.md) (committed and rebuilt, like the ADR index), so a current page means the generator, the sources, and the ADR citations agree. Reads only the
repository's files — the same answer in both run modes, so the build run skips it.
```
