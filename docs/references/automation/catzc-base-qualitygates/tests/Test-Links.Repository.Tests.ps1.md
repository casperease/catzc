---
catzc:
  immutable:
    with_body_sha: "41d47ff568e9"
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Links.Repository.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-links-repository-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Test-Links.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Repository code links (automation comments)' -Tag 'L1',...`, written with `#`.

```text
The real repository keeps its links aligned and resolving
([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)). Integrity checks over the shipped tree, in two tiers: L1 is the
fast structural pass over the automation code's comments; L2 is the full pass over every git-tracked file — every markdown
target and #fragment — plus the formatter-stable check and the editor rule that makes code links clickable.
Rule-tag citations and analyzer mappings are validated elsewhere (Get-TestTagViolations, Get-AnalyzerAdrCoverage).
```
