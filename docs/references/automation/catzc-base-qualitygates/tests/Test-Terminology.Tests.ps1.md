---
catzc:
  immutable:
    with_body_sha: "745282c098fe"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Terminology.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-terminology-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.QualityGates {`, written with `#`.

```text
Default happy path: config loads, dictionary is current, every term is referenced. Both mocks return the
production shapes — the typed registry record and Build-TerminologyDictionary's per-category rows.
```
