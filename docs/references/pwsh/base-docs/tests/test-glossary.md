# pwsh/Base.Docs/tests/Test-Glossary.Tests.ps1

The tests of `Test-Glossary`, in two blocks.

## Orchestration

`Test-Glossary` orchestrates the six checks. Here every check and the glossary readers are mocked, so the tests pin the order, the report,
the `-PassThru` shape and the single aggregate throw ([ADR-AUTO-FAILFAST](../../../../drs/automation/fail-fast-with-asserts.md)). The checks
themselves are covered by their own L0 files.

## Real sources

The real glossary sources against the real decision records, tests and tracked files. G1 and G4 reach git (the tracked-file listing), so
this is L2; the answer is the same in both run modes, so the build run skips it. `Test-Glossary` runs once over the real sources and every
`It` reads its part of that one result
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-ONEIMPORTPERCASE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneimportpercase)): it prefixes each
check's issues with the check's code, pinned at L0 above, so each check's `It` reads its own issues from that run rather than running the
check a second time.
