# pwsh/Base.Drs/tests/Resolve-DrsLinkTarget.Tests.ps1

The tests of `Resolve-DrsLinkTarget`: a markdown link in a file under `docs/drs/`, resolved relative to its file
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)) to its path under
`docs/drs/`.

## Fixtures

The command is pure path logic, so the fixture root need not exist. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
