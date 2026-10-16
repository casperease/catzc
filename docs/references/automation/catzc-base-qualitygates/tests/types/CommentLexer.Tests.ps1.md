---
catzc:
  immutable:
    with_body_sha: dfc058b41e36
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentLexer.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests/types
    name: comment-lexer-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-LINK#{1,6}
---

# automation/Catzc.Base.QualityGates/tests/types/CommentLexer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CommentLexer' -Tag 'L0', 'logic' {`, written with `#`.

```text
CommentLexer finds the comment spans a code link may live in
([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)) and must never mistake a string for
one ([ADR-REPO-LINK#6](/docs/adr/repository/markdown-links.md#rule-adr-repo-link6)). Each case asserts the comment
texts found in a short widget/gadget snippet.
```
