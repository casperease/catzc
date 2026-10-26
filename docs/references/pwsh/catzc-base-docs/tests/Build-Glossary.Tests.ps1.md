# pwsh/Base.Docs/tests/Build-Glossary.Tests.ps1

The tests of `Build-Glossary`: the logic over mocked inputs, and the real glossary page.

## Logic

`Build-Glossary` renders the merged glossary into one markdown page. The logic tests mock the three inputs, the glossary (real
`GlossaryEntry`, `GlossaryConcept` and `GlossaryOptions` types), the ADR citation map (a real `DrsCitationMap` over a fixture ADR) and the
`drs.yml` domains, and write into `$TestDrive`. Fixture terms and codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). A
rule whose link is longer than a line is wrapped the way Prettier does, so the formatter leaves the page unchanged.

## Real page

The real glossary page against the real sources. The importer's janitor materialises the [glossary](../../../../drs/glossary.md), committed
and rebuilt like the ADR index, so a current page means the generator, the sources and the ADR citations agree. The block reads only the
repository's files, the same answer in both run modes, so the build run skips it.
