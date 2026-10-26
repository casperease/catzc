# pwsh/Base.QualityGates/configs/test-policy.yml

The test policy: what a test may do to the environment it reaches
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../../drs/automation/test-automation.md#rule-adr-auto-test-testinginproduction)).

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `Catzc.Base.QualityGates.TestPolicyConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

`l4_mutation` maps a target environment to how far an L4 test, one of the released system after final approval, may change it:

- `read-only`: probes and observations only.
- `synthetic`: transactions the system is built to accept and clean up.

An environment not listed is read-only. Example: `{ pre-prod: synthetic }`.
