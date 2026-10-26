# pwsh/Base.Docs/tests/types/GitHubAnchor.Tests.ps1

The tests of the GitHub slug and anchor set a markdown link's `#fragment` must name
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). The slug cases are
the shapes the repository's headings take: rule headings, responsibility headings with an em dash, code spans, and duplicates.
