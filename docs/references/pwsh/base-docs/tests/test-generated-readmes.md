# pwsh/Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1

The tests of `Test-GeneratedReadmes`, in two blocks.

## Fixture READMEs

Fixture READMEs in `$TestDrive`: the mappings, git's ignore check and the index are mocked, and the repository root is redirected to the
fixture, so each test pins one rule. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The real repository

The quality gate over the real repository. `readme.yml`, expanded by `Get-ReadmeMappings`, is the registry of folders whose `README.md` is
generated from a docs source, a derived artifact never authored in place, so each must be gitignored, out of git, and current with its
source. Hand-authored READMEs are exactly the folders not in `readme.yml`; they are individually un-ignored in `.gitignore` and are out of
scope. See [ADR-REPO-README](../../../../drs/repository/generated-readmes.md).

The block reads only the repository's files and git index, through the source-tree-only `Get-ReadmeMappings`, the same answer in both run
modes, so the build run skips it. It is an L2 test: it drives the real git CLI, and it skips itself when git is absent or the run is not
inside a work tree, for example from an exported tarball, per the test-automation tiering ADR.
