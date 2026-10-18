# automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GeneratedReadmes' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GeneratedReadmes over fixture READMEs in $TestDrive: the mappings, git's ignore check, and the index are mocked,
and the repository root is redirected to the fixture, so each test pins one rule. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Generated READMEs are gitignored, untracked, and current' -Tag...`, written with `#`.

```text
The quality gate over the real repository. readme.yml (expanded by Get-ReadmeMappings) is the registry of folders whose
README.md is generated from a docs/ source — a derived artifact, never authored in place — so each must be
gitignored, out of git, and current with its source. Hand-authored READMEs are exactly the folders NOT in
readme.yml; they are individually un-ignored in .gitignore and are out of scope here. See
[ADR-REPO-README](/docs/adr/repository/generated-readmes.md).

Reads only the repository's files and git index (through the source-tree-only Get-ReadmeMappings) — the same
answer in both run modes, so the build run skips it.
```

## comment:3

Above `if (-not (Get-Command git -ErrorAction Ignore)) {`, written with `#`.

```text
L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
(e.g. running from an exported tarball), per the test-automation tiering ADR.
```
