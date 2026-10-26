# pwsh/Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Managed root config files agree with .gitignore and git tracking'`, written with `#`.

```text
Integrity test for managed root config files, through the quality gates Test-RootConfigFiles and
Test-RootAnalyzerSettings ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

rootconfig.yml is the registry of repository-root files fully managed by the source-of-truth automation.
Per opted-in entry, `committed` decides git membership, and registry, .gitignore, and git's tracked set
must agree:
  committed false -> the target is a derived, gitignored artifact: matched by an ignore rule and absent
                     from tracking (removed with `git rm --cached` if it was ever committed).
  committed true  -> the target is tracked (needed before the importer runs) and NOT ignored.
and every target is a real file, a `source` target its template under the generated head. Mirrors the
generated-README integrity test (Test-GeneratedReadmes.Tests.ps1). See
[ADR-REPO-ROOTCFG](/docs/drs/repository/generated-root-configs.md).
```

## comment:2

Above `if (-not (Get-Command git -ErrorAction Ignore)) {`, written with `#`.

```text
L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
(e.g. running from an exported tarball), per the test-automation tiering ADR.
```

## comment:3

Above `Describe 'Root PSScriptAnalyzerSettings.psd1 copy'`, written with `#`.

```text
The root PSScriptAnalyzerSettings.psd1 has a consumer-format contract of its own: PSScriptAnalyzer requires
a literal-hashtable settings file at the path it is given. The target is a headed copy of its template,
which Test-RootConfigFiles compares byte for byte — what remains to prove is that a consumer opening the
ROOT path parses the settings under the head.
```
