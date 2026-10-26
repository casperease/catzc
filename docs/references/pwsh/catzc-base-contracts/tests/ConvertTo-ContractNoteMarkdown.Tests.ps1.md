# pwsh/Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1

Tests `ConvertTo-ContractNoteMarkdown`. A note is written as a comment, where a citation is a repository-rooted code link
([ADR-REPO-LINK-CODELINKS](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)); in a list item of a generated page
it is markdown, so a rooted link turns relative to the page
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). Fixtures are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
