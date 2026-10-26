# pwsh/Base.QualityGates/tests/Test-Markdownlint.Tests.ps1

The tests of `Test-Markdownlint`: a logic test that runs the real markdownlint over a fixture file, and an integrity block over the
repository.

## Repository markdown integrity

The integrity block proves that the actual repository markdown is lint-clean. Unlike the logic test, it binds to the real repository:
`Test-Markdownlint` with no `-Path` scans its default content scope
([ADR-AUTO-TEST-LOGICANDINTEGRITY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)). It is L2 because it
drives the markdownlint-cli2 CLI, and it self-skips when the CLI is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).

The block sits behind a protected glob ([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): a repeat local run over an
unchanged `markdown-scope` globset, which holds the scan's inputs, the in-scope markdown plus the markdownlint config, is skipped. In a
pipeline the protection is ignored and the scan always runs full. The block is source-only, because it reads the repository's markdown,
which gives the same answer in both run modes.
