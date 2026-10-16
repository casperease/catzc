---
catzc:
  immutable:
    with_body_sha: "768683e5d77d"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests/types
    name: glossary-entry-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlossaryEntry' -Tag 'L0', 'logic' {`, written with `#`.

```text
Validates the compiled GlossaryEntry result type — one merged concept with its owning module, source path, and
options. Fixture terms are neutral (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
