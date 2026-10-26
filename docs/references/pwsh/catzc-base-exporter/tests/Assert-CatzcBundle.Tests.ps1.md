# pwsh/Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:newFixtureBuild = {`, written with `#`.

```text
A hand-made, well-formed build of two neutral modules
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): widget is selected (its type
source
ships under Catzc.Base.Widget/types/), gadget's type source rides along under .compiled/types/ (every build
ships the full type set). typesHash comes from the one implementation, over the same two sources.
```

## comment:2

Above `$script:resealBuild = {`, written with `#`.

```text
Rewrites build.json after a fixture mutation, keeping the content hash current so only the mutated
property is under test.
```
