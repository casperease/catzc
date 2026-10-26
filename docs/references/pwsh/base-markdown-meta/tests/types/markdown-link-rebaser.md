# pwsh/Base.MarkdownMeta/tests/types/MarkdownLinkRebaser.Tests.ps1

The tests of the `MarkdownLinkRebaser` type.

## Why it is shaped so

A generated README copies an article into another folder, so its relative links are rebased to resolve there
([ADR-REPO-README-WORKINGLINKS](../../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-workinglinks)).
