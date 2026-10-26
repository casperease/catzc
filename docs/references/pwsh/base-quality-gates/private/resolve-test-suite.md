# pwsh/Base.QualityGates/private/Resolve-TestSuite.ps1

Resolves a named test suite, a globset's declared verify scope in globs.yml, into Test-Automation's run parameters. It is the resolver
behind the `-Suite` parameter.

## help

### synopsis

Resolves a named test suite — a globset's declared verify scope (globs.yml `verify:`) — into Test-Automation's run parameters.

### description

The -Suite resolver. A test suite is a named, declared selection of tests
([ADR-AUTO-TEST-TESTSUITE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-testsuite)): a globset's `verify:` scope, the
modules whose tests verify a change in that area-of-control and the tier to run them through (the blast-radius marker role,
[FDR-GLOBS-EVERYSETHASLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-everysethaslayer)). This looks the named globset up in
the registry (an unknown name throws there, naming the config) and returns that scope. A globset without a verify scope is not a test suite;
it throws with the remedy: declare one in globs.yml.

### parameter `Name`

The name of a test suite — its globset's name (globs.yml).

### outputs

`[pscustomobject]` with Modules (`string[]`) and Level (int 0-3).
