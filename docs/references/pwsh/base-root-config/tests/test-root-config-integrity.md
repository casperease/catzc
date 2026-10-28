# pwsh/Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1

The integrity test of the managed root config files, through the quality gates `Test-RootConfigFiles` and `Test-RootAnalyzerSettings`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). It mirrors the generated-README
integrity test (`Test-GeneratedReadmes.Tests.ps1`). See [ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md).

## What must agree

`rootconfig.yml` is the registry of repository-root files fully managed by the source-of-truth automation. Per opted-in entry, `committed`
decides git membership, and the registry, `.gitignore` and git's tracked set must agree:

- `committed: false`: the target is a derived, gitignored artifact, matched by an ignore rule and absent from tracking (removed with
  `git rm --cached` if it was ever committed);
- `committed: true`: the target is tracked (needed before the importer runs) and not ignored.

Every target is a real file, and a `source` target is its template under the generated head.

## Self-skip

It is an L2 test that drives the real git CLI. It skips itself when git is absent or the run is not inside a work tree (for example from an
exported tarball), per the test-automation tiering record.

## The analyzer settings

The root `PSScriptAnalyzerSettings.psd1` has a consumer-format contract of its own: PSScriptAnalyzer requires a literal-hashtable settings
file at the path it is given. The target is a headed copy of its template, which `Test-RootConfigFiles` compares byte for byte, so what
remains to prove is that a consumer opening the root path parses the settings under the head.
