# pwsh/Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Tooling.Inspiration.InspirationConfig'`, written with `#`.

```text
InspirationConfig and its InspirationEntry over neutral fixtures (widget/gadget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): the mapping, the one declared default
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and every load-time rejection,
including the communication-form root ([ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM](/docs/drs/automation/path-representation.md#rule-adr-auto-path-storedcommunicationform)).
```

## comment:2

Above `Describe 'Catzc.Tooling.Inspiration.InspirationConfig'`, written with `#`.

```text
Every load-time rejection is pinned, so a root in any but the portable stored form can never slip into a loaded
config.
```
