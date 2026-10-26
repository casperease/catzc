# pwsh/Base.QualityGates/tests/Test-Spelling.Tests.ps1

The tests of `Test-Spelling`: a logic test that runs the real cspell over a fixture file, and an integrity block over the repository. The
cspell globs are relative to the repository root, which is the working directory of `Test-Spelling`, so the logic test uses the committed
clean fixture by its repo-relative path.

## Repository spelling integrity

The integrity block proves that the actual repository content is spell-clean. Unlike the logic test, it binds to the real repository:
`Test-Spelling` with no `-Path` scans its default content scope
([ADR-AUTO-TEST-LOGICANDINTEGRITY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)). It is L2 because it
drives the cspell CLI, and it self-skips when cspell is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).

The block sits behind a protected glob ([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): a repeat local run over an
unchanged `repository` globset, every tracked file under every named root, which covers cspell's content scope and its own configs, is
skipped. In a pipeline the protection is ignored and the scan always runs full. The block is source-only, because it reads the repository's
files, which give the same answer in both run modes.

The test reads the scan's default content types from the config, and `cspell.yml` `ignorePaths` drops vendored code. Any such tracked file
outside the `repository` globset could change the scan's outcome without re-keying the protection.
