# pwsh/Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())`, written with `#`.

```text
Unique sandbox per run; the seam mock returns ABSOLUTE fixture paths, which Resolve-RepoPath
passes through unchanged — so only the file-universe seam needs mocking.
```

## comment:2

Above `Describe 'Repository guid integrity'`, written with `#`.

```text
source-only: it scans the repository's tracked files, which give the same answer in both run modes. The check is the
quality gate Test-ManagedGuids ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the
scan against the registry, and the 'repository' globset covering everything the scan reads — so the protection
skip below is sound ([ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG](/docs/drs/repository/protected-globs.md#rule-adr-repo-protglob-includesownconfig)).
```
