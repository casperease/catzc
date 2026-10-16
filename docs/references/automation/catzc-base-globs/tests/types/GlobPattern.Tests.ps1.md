---
catzc:
  immutable:
    with_body_sha: "599c17e2bd4e"
    path: docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
    folder: docs/references/automation/catzc-base-globs/tests/types
    name: glob-pattern-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-FLOW-CD-GLOBS#{2,3}
---

# automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobPattern' -Tag 'L0', 'logic' {`, written with `#`.

```text
The dialect's truth table ([ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2)) and the
constructor guard
([ADR-FLOW-CD-GLOBS#3](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs3)): per-segment PowerShell
wildcards, '**' as the only cross-segment operator (zero or more whole segments), case-sensitive; a
malformed pattern never produces an instance.
```
