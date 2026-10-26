# pwsh/Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1

The test of `Get-RepositoryGuids` and the repository guid integrity check. The logic part runs in a unique sandbox per run, and its file
universe seam is mocked to return absolute fixture paths, which `Resolve-RepoPath` passes through unchanged, so only that seam needs a mock.

## Integrity check

The integrity part is source-only: it scans the repository's tracked files, which give the same answer in both run modes. The check is the
quality gate `Test-ManagedGuids`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). It runs the scan against the
registry, and it relies on the `repository` globset covering everything the scan reads, so the protection skip is sound
([ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-includesownconfig)).
