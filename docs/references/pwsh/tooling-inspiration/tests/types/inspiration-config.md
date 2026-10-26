# pwsh/Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1

The tests of `InspirationConfig` and its `InspirationEntry` over neutral fixtures
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Coverage

- The mapping from YAML to the typed record.
- The one declared default
  ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
- Every load-time rejection, including the communication-form root
  ([ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM](../../../../../drs/automation/path-representation.md#rule-adr-auto-path-storedcommunicationform)),
  so a root in any but the portable stored form can never slip into a loaded config.
