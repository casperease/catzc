# automation/pwsh/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'orders every dependency before its dependents (diamond + independent...`, written with `#`.

```text
Isolate the sort from the shipped tools.yml by mocking the config seam to a controlled graph: this
verifies the ALGORITHM (dependencies-before-dependents, a diamond, an independent root, and cycle
detection), never the production tool set
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)/[ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)). 'base/mid1/mid2/top/lone' are fixture
identities ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) — nothing here
binds to a real tool name.
```

## comment:2

Above `BeforeAll {`, written with `#`.

```text
Binds to the shipped config as a SET, asserting invariants that hold for every tool — never a
specific tool name or a hardcoded pairing
([ADR-AUTO-TEST-GENERICTEMPLATETESTS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)). The ordering algorithm
itself is proven by the
logic Context above.
```

## comment:3

Above `$script:allTools = Get-Content (Get-Config -Config tools -ListOwners).Path...`, written with `#`.

```text
The shipped file wherever its owning module keeps it (Catzc.Base.Execution), read raw so the set
compared against is the YAML itself, not the typed model Get-ToolInstallOrder reads.
```
