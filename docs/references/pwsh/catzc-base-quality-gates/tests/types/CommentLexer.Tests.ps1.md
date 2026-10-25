# pwsh/Catzc.Base.QualityGates/tests/types/CommentLexer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CommentLexer'`, written with `#`.

```text
CommentLexer finds the comment spans a code link may live in
([ADR-REPO-LINK-KINDBYFILE](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)) and must never mistake a string for
one ([ADR-REPO-LINK-STRINGSAREDATA](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-stringsaredata)). Each case asserts the comment
texts found in a short widget/gadget snippet.
```
