# pwsh/Base.QualityGates/tests/Format-Links.Tests.ps1

The tests of `Format-Links`, the link aligner and the repository-wide migration
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)), in isolation.

## Fixture

Every test builds its own fixture repository in `$TestDrive`: a two-record index with neutral widget and gadget codes
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)), an `.editorconfig`,
and the source files under test. It aligns only that tree (`-RepositoryRoot`, `-Path`).
