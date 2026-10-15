---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md
    kind: comment-page
    body_sha: cadd3b9038e1
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-LanguageTestFolders' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-LanguageTestFolders over a fixture repository in $TestDrive (Get-RepositoryRoot and the go config mocked): catzc
modules under automation/, Go test folders under the go/ root, Python test folders under python/ and Bash test folders
under bash/. Neutral
fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `New-FixtureFile $script:repo 'go/tests/.cache/cache_test.go'`, written with `#`.

```text
Not test folders: dot-prefixed folders, a folder left with only generated files, a Python folder with no
test_*.py file, and a Bash folder with no .bats file.
```
