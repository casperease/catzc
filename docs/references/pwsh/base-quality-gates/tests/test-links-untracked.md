# pwsh/Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1

The test that a markdown link must resolve on GitHub, which has only what git tracks
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). A fixture repository
in `$TestDrive` stands in for the loaded repository, and its tracked set is mocked. The fixtures use neutral widget and gadget names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
