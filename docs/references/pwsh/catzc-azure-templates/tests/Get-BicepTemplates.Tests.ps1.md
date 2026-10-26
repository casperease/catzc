# pwsh/Azure.Templates/tests/Get-BicepTemplates.Tests.ps1

<!-- cspell:ignore sampl deriv -->

The L0 tests of template discovery against the fixture tree.

## Setup once

These are read-only discovery tests. The boundary mocks and the config-cache reset run once, not per test. Discovery already caches on the
fixture root across tests, and no test mutates the fixture tree or config, so the warm caches are correct to share. A per-test `configCache`
reset only forced a needless cold re-parse
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)). The cache-behaviour tests
invalidate `bicepTemplatesCache` inside their own `It`, independent of this setup.

## Fixtures, never shipped

Discovery runs from the test fixtures, never the shipped `infrastructure/templates`, and identity (environment and customer validation)
resolves from the test config fixture, never the shipped `azure.yml`.

The check that the root is not the shipped one compares against the actual shipped root, not an `*infrastructure*templates*` substring: the
module folder is named `Catzc.Azure.Templates`, so the fixture path legitimately contains `infrastructure` too.
