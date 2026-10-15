---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentFormatter.Tests.ps1.md
    kind: test-asset
    body_sha: f16a32b627aa
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#5
---

# automation/Catzc.Base.QualityGates/tests/types/CommentFormatter.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'CommentFormatter' -Tag 'L0', 'logic' {`.

```text
CommentFormatter keeps a comment residue in its one-liner shape — one insight line, then the citations and the docs
link ([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5),
[ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)) — fixing what is
mechanical and reporting what needs a person, by comments.yml's rules
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). Each case runs the
formatter over a short widget/gadget snippet with a line limit of 80.
```
