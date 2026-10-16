---
catzc:
  immutable:
    with_body_sha: "71f1278ddc5b"
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-repository-guids-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-PROTGLOB#6
---

# automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())`, written with `#`.

```text
Unique sandbox per run; the seam mock returns ABSOLUTE fixture paths, which Resolve-RepoPath
passes through unchanged — so only the file-universe seam needs mocking.
```

## comment:2

Above `Describe 'Repository guid integrity' -Tag 'L2', 'integrity', 'source-only' {`, written with `#`.

```text
source-only: it scans the repository's tracked files, which give the same answer in both run modes. The check is the
quality gate Test-ManagedGuids ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the
scan against the registry, and the 'repository' globset covering everything the scan reads — so the protection
skip below is sound ([ADR-REPO-PROTGLOB#6](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6)).
```
