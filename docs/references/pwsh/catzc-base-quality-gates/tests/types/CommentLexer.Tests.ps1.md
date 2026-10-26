# pwsh/Base.QualityGates/tests/types/CommentLexer.Tests.ps1

The tests of the `CommentLexer` type, which finds the comment spans a code link may live in
([ADR-REPO-LINK-KINDBYFILE](../../../../../drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)) and must never mistake a string
for one ([ADR-REPO-LINK-STRINGSAREDATA](../../../../../drs/repository/markdown-links.md#rule-adr-repo-link-stringsaredata)). Each case
asserts the comment texts found in a short widget and gadget snippet.
