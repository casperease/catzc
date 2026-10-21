# pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a named test suite — a globset's declared verify scope (globs.yml `verify:`) — into Test-Automation's run parameters.

### description

The -Suite resolver. A test suite is a named, declared selection of tests
([ADR-AUTO-TEST-TESTSUITE](../../../../adr/automation/test-automation.md#rule-adr-auto-test-testsuite)): a globset's `verify:` scope, the
modules whose tests verify a change in that area-of-control and the tier to run them through (the blast-radius marker role,
[FDR-CD-GLOBS-EVERYSETHASLAYER](../../../../adr/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer)). This looks the
named globset up in the registry (an unknown name throws there, naming the config) and returns that scope. A globset without a verify scope
is not a test suite; it throws with the remedy: declare one in globs.yml.

### parameter `Name`

The name of a test suite — its globset's name (globs.yml).

### outputs

`[pscustomobject]` with Modules (`string[]`) and Level (int 0-3).
