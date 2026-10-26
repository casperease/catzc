# pwsh/Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1

A poka-yoke backstop: no `<token>`-shaped text in the title of a test that is not data-driven, checked over the real tree through its
quality gate `Test-TestTitles` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

Pester treats `<word>` in an `It`, `Describe` or `Context` title as its name-template syntax. Without `-ForEach` or `-TestCases` data the
token is almost always prose, and it throws under the strict tests
([ADR-AUTO-TEST-FILEPARALLELISM](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism)) at name expansion, far
from the cause. The gate bans the pattern outright: a title with a token must carry `-ForEach` data. The titles in this file spell out
"angle-bracket token", because a literal one would fire the very trap.

The test is source-only: it parses the repository's test files, which give the same answer in both run modes.
